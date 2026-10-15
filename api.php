<?php
require_once __DIR__ . '/config.php';

header('Content-Type: application/json; charset=utf-8');

$headers = getallheaders();
$sentKey = $headers['X-Api-Key'] ?? $headers['x-api-key'] ?? '';
if (!hash_equals(API_SECRET, $sentKey)) {
    http_response_code(401);
    echo json_encode(['error' => 'Unauthorized']);
    exit;
}

$ENTITIES = ['employees', 'sla_projects', 'projects', 'employee_summary'];

function isValidPeriod(string $period): bool {
    return (bool) preg_match('/^\d{4}-\d{2}$/', $period);
}

function rowToEmployee(array $r): array {
    return [
        'name' => $r['name'],
        'role' => $r['role'],
        'tags' => json_decode($r['tags'], true) ?? [],
        'joinDate' => $r['join_date'] ?? '',
        'targetDate' => $r['target_date'] ?? '',
    ];
}

function rowToSlaProject(array $r): array {
    return [
        'id' => (int) $r['id'],
        'period' => $r['period'] ?? '',
        'name' => $r['name'],
        'startDate' => $r['start_date'] ?? '',
        'actualEndDate' => $r['actual_end_date'] ?? '',
        'workType' => $r['work_type'] ?? '',
        'stages' => json_decode($r['stages'], true) ?? [],
    ];
}

function rowToProject(array $r): array {
    return [
        'id'            => (int) $r['id'],
        'name'          => $r['name'],
        'client'        => $r['client'] ?? '',
        'start'         => $r['start_date'] ?? '',
        'end'           => $r['end_date'] ?? '',
        'status'        => $r['status'] ?? '',
        'dept'          => $r['dept'] ?? '',
        'remarks'       => $r['remarks'] ?? '',
        'evidenceFile'  => $r['evidence_file'] ?? '',
        'evidenceData'  => $r['evidence_data'] ?? '',
        'slaStageId'    => $r['sla_stage_id'] ?? '',   // tahapan SLA yang dipilih
    ];
}

function emptyStrToNull($v) {
    return ($v === '' || $v === null) ? null : $v;
}

$db = getDb();
$method = $_SERVER['REQUEST_METHOD'];
$entity = $_GET['entity'] ?? '';

if (!in_array($entity, $ENTITIES, true)) {
    http_response_code(400);
    echo json_encode(['error' => 'Invalid entity']);
    exit;
}

if ($method === 'GET') {
    // ── Special: employee_summary ─────────────────────────────
    if ($entity === 'employee_summary') {
        $year = $_GET['year'] ?? '';
        if (!preg_match('/^\d{4}$/', $year)) {
            http_response_code(400);
            echo json_encode(['error' => 'Invalid year']);
            exit;
        }

        // 1. Employees per period (all months of year)
        $stmt = $db->prepare("SELECT period, name, role, tags FROM employees WHERE period LIKE ? ORDER BY period, id");
        $stmt->execute([$year . '-%']);
        $empRows = $stmt->fetchAll(PDO::FETCH_ASSOC);

        // Build structure: result[period][name] = {role, tags, slaTotal, slaDone, slaItems}
        $result = [];
        for ($m = 1; $m <= 12; $m++) {
            $result[$year . '-' . str_pad($m, 2, '0', STR_PAD_LEFT)] = [];
        }
        foreach ($empRows as $r) {
            $period = $r['period'];
            $name   = $r['name'];
            if (!isset($result[$period])) $result[$period] = [];
            $result[$period][$name] = [
                'name'     => $name,
                'role'     => $r['role'],
                'tags'     => json_decode($r['tags'], true) ?? [],
                'slaTotal' => 0,
                'slaDone'  => 0,
                'slaItems' => [],
            ];
        }

        // 2. SLA subtasks – loop through sla_projects for year
        $stmt2 = $db->prepare("SELECT period, name AS project_name, stages FROM sla_projects WHERE period LIKE ?");
        $stmt2->execute([$year . '-%']);
        $slaRows = $stmt2->fetchAll(PDO::FETCH_ASSOC);

        foreach ($slaRows as $sla) {
            $period  = $sla['period'];
            $project = $sla['project_name'];
            $stages  = json_decode($sla['stages'], true) ?? [];

            foreach ($stages as $stage) {
                $stageName = $stage['name'] ?? '';
                foreach ($stage['subtasks'] ?? [] as $st) {
                    $isDone = (bool)($st['isDone'] ?? false);
                    $desc   = $st['desc'] ?? '';
                    $tdate  = $st['targetDate'] ?? '';

                    // Support both 'emps' (array) and 'emp' (string)
                    $empList = [];
                    if (!empty($st['emps']) && is_array($st['emps'])) {
                        $empList = $st['emps'];
                    } elseif (!empty($st['emp'])) {
                        // emp may be comma-separated e.g. "Irwan, Yudi Setiawan"
                        $empList = array_map('trim', explode(',', $st['emp']));
                    }

                    foreach ($empList as $eName) {
                        $eName = trim($eName);
                        if ($eName === '' || $eName === '-') continue;
                        if (!isset($result[$period][$eName])) {
                            // Employee not in employees table for this period but has SLA work
                            $result[$period][$eName] = [
                                'name' => $eName, 'role' => '', 'tags' => [],
                                'slaTotal' => 0, 'slaDone' => 0, 'slaItems' => [],
                            ];
                        }
                        $result[$period][$eName]['slaTotal']++;
                        if ($isDone) $result[$period][$eName]['slaDone']++;
                        $result[$period][$eName]['slaItems'][] = [
                            'project' => $project, 'stage' => $stageName,
                            'desc' => $desc, 'targetDate' => $tdate, 'isDone' => $isDone,
                        ];
                    }
                }
            }
        }

        // Convert inner maps to arrays for JSON
        $out = [];
        foreach ($result as $period => $empMap) {
            $out[$period] = array_values($empMap);
        }
        echo json_encode($out);
        exit;
    }

    // ── employees?year= ───────────────────────────────────────
    if ($entity === 'employees' && isset($_GET['year'])) {
        $year = $_GET['year'];
        if (!preg_match('/^\d{4}$/', $year)) {
            http_response_code(400);
            echo json_encode(['error' => 'Invalid year']);
            exit;
        }
        $stmt = $db->prepare("SELECT * FROM employees WHERE period LIKE ? ORDER BY id");
        $stmt->execute([$year . '-%']);
        $result = [];
        for ($m = 1; $m <= 12; $m++) $result[$year . '-' . str_pad($m, 2, '0', STR_PAD_LEFT)] = [];
        while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
            $result[$row['period']][] = rowToEmployee($row);
        }
        echo json_encode($result);
        exit;
    }

    // ── projects?all=1 or projects?year= ─────────────────────
    if ($entity === 'projects' && (isset($_GET['all']) || isset($_GET['year']))) {
        if (isset($_GET['year']) && preg_match('/^\d{4}$/', $_GET['year'])) {
            $y = $_GET['year'];
            $stmt = $db->prepare("SELECT * FROM projects WHERE YEAR(end_date) = ? OR (end_date IS NULL AND (YEAR(start_date) = ? OR period LIKE ?)) ORDER BY start_date ASC, id ASC");
            $stmt->execute([$y, $y, $y . '-%']);
        } else {
            $stmt = $db->query("SELECT * FROM projects ORDER BY start_date ASC, id ASC");
        }
        $rows = $stmt->fetchAll(PDO::FETCH_ASSOC);
        echo json_encode(array_map('rowToProject', $rows));
        exit;
    }

    // ── sla_projects?all=1 or sla_projects?year= ─────────────
    if ($entity === 'sla_projects' && (isset($_GET['all']) || isset($_GET['year']))) {
        if (isset($_GET['year']) && preg_match('/^\d{4}$/', $_GET['year'])) {
            $y = $_GET['year'];
            $stmt = $db->prepare("SELECT * FROM sla_projects WHERE YEAR(start_date) = ? OR period LIKE ? ORDER BY start_date ASC, id ASC");
            $stmt->execute([$y, $y . '-%']);
        } else {
            $stmt = $db->query("SELECT * FROM sla_projects ORDER BY start_date ASC, id ASC");
        }
        $rows = $stmt->fetchAll(PDO::FETCH_ASSOC);
        echo json_encode(array_map('rowToSlaProject', $rows));
        exit;
    }

    $period = $_GET['period'] ?? '';
    if (!isValidPeriod($period)) {
        http_response_code(400);
        echo json_encode(['error' => 'Invalid period']);
        exit;
    }

    $stmt = $db->prepare("SELECT * FROM $entity WHERE period = ? ORDER BY id");
    $stmt->execute([$period]);
    $rows = $stmt->fetchAll(PDO::FETCH_ASSOC);

    $mapFn = ['employees' => 'rowToEmployee', 'sla_projects' => 'rowToSlaProject', 'projects' => 'rowToProject'][$entity];
    echo json_encode(array_map($mapFn, $rows));
    exit;
}


if ($method === 'POST') {
    $period = $_GET['period'] ?? '';
    if (!isValidPeriod($period)) {
        http_response_code(400);
        echo json_encode(['error' => 'Invalid period']);
        exit;
    }

    $items = json_decode(file_get_contents('php://input'), true);
    if (!is_array($items)) {
        http_response_code(400);
        echo json_encode(['error' => 'Invalid body']);
        exit;
    }

    $db->beginTransaction();
    try {
        if ($entity === 'employees') {
            $db->prepare("DELETE FROM employees WHERE period = ?")->execute([$period]);
            $ins = $db->prepare(
                'INSERT INTO employees (period, name, role, join_date, target_date, tags) VALUES (?, ?, ?, ?, ?, ?)'
            );
            foreach ($items as $it) {
                $ins->execute([
                    $period,
                    $it['name'] ?? '',
                    $it['role'] ?? '',
                    emptyStrToNull($it['joinDate'] ?? null),
                    emptyStrToNull($it['targetDate'] ?? null),
                    json_encode($it['tags'] ?? [], JSON_UNESCAPED_UNICODE),
                ]);
            }
        } elseif ($entity === 'sla_projects') {
            $ins = $db->prepare(
                'INSERT INTO sla_projects (id, period, name, start_date, actual_end_date, work_type, stages) VALUES (?, ?, ?, ?, ?, ?, ?)
                 ON DUPLICATE KEY UPDATE period=VALUES(period), name=VALUES(name), start_date=VALUES(start_date), actual_end_date=VALUES(actual_end_date), work_type=VALUES(work_type), stages=VALUES(stages)'
            );
            foreach ($items as $it) {
                $projId = !empty($it['id']) ? $it['id'] : round(microtime(true) * 1000);
                $pStartDate = emptyStrToNull($it['startDate'] ?? null);
                $itPeriod = !empty($it['period']) ? $it['period'] : (!empty($pStartDate) ? substr($pStartDate, 0, 7) : $period);
                $ins->execute([
                    $projId,
                    $itPeriod,
                    $it['name'] ?? '',
                    $pStartDate,
                    emptyStrToNull($it['actualEndDate'] ?? null),
                    $it['workType'] ?? '',
                    json_encode($it['stages'] ?? [], JSON_UNESCAPED_UNICODE),
                ]);
            }
        } else { // projects
            $ins = $db->prepare(
                'INSERT INTO projects (id, period, name, client, start_date, end_date, status, dept, remarks, evidence_file, evidence_data, sla_stage_id) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
                 ON DUPLICATE KEY UPDATE name=VALUES(name), client=VALUES(client), start_date=VALUES(start_date), end_date=VALUES(end_date), status=VALUES(status), dept=VALUES(dept), remarks=VALUES(remarks), evidence_file=VALUES(evidence_file), evidence_data=VALUES(evidence_data), sla_stage_id=VALUES(sla_stage_id)'
            );
            foreach ($items as $it) {
                $ins->execute([
                    $it['id'],
                    $period,
                    $it['name'] ?? '',
                    $it['client'] ?? '',
                    emptyStrToNull($it['start'] ?? null),
                    emptyStrToNull($it['end'] ?? null),
                    $it['status'] ?? '',
                    $it['dept'] ?? '',
                    $it['remarks'] ?? '',
                    $it['evidenceFile'] ?? '',
                    $it['evidenceData'] ?? '',
                    emptyStrToNull($it['slaStageId'] ?? null),
                ]);
            }
        }

        $db->commit();
    } catch (Exception $e) {
        $db->rollBack();
        http_response_code(500);
        echo json_encode(['error' => 'Save failed']);
        exit;
    }

    echo json_encode(['ok' => true]);
    exit;
}

http_response_code(404);
echo json_encode(['error' => 'Not found']);
