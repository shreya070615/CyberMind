
import type { Alert, Incident, PlaybookEffectiveness, Severity } from './types';

const generateTimestamp = (daysAgo: number): string => {
  const date = new Date();
  date.setDate(date.getDate() - daysAgo);
  return date.toISOString();
};

export const mockAlerts: Alert[] = [
  {
    id: 'ALERT-001',
    timestamp: generateTimestamp(1),
    sourceSystem: 'SIEM',
    eventType: 'Multiple Failed Login Attempts',
    description: 'User "admin" failed to log in 5 times from IP 192.168.1.100.',
    severity: 'Medium',
    rawLogSnippet: '{"timestamp": "...", "user": "admin", "action": "login", "status": "failed", "ip": "192.168.1.100", "reason": "bad password"}',
    behavioralContextSummary: 'User "admin" typically logs in from the internal network during business hours. This login attempt was outside of normal hours.',
    anomalyDetectionSummary: "Deviation from baseline: Login time is 3 standard deviations outside the user's norm.",
  },
  {
    id: 'ALERT-002',
    timestamp: generateTimestamp(2),
    sourceSystem: 'EDR',
    eventType: 'Malware Detected',
    description: 'File "svchost.exe" in C:\\Temp behaved like known malware "WannaCry".',
    severity: 'High',
    rawLogSnippet: '{"timestamp": "...", "file": "C:\\\\Temp\\\\svchost.exe", "signature": "WannaCry.gen", "action": "quarantined"}',
  },
  {
    id: 'ALERT-003',
    timestamp: generateTimestamp(3),
    sourceSystem: 'Firewall',
    eventType: 'Unusual Outbound Traffic',
    description: 'High volume of outbound traffic to IP 203.0.113.55 on port 4444 from server "DB-PROD-01".',
    severity: 'High',
    rawLogSnippet: '{"timestamp": "...", "src_ip": "10.0.0.5", "dest_ip": "203.0.113.55", "dest_port": 4444, "bytes_out": 54321098}',
    anomalyDetectionSummary: 'Server "DB-PROD-01" has never communicated with this external IP before. The data volume is anomalous.',
  },
  {
    id: 'ALERT-004',
    timestamp: generateTimestamp(4),
    sourceSystem: 'CloudTrail',
    eventType: 'IAM Policy Change',
    description: 'IAM policy "AdminAccess" was attached to user "temp-dev".',
    severity: 'Low',
    rawLogSnippet: '{"eventSource": "iam.amazonaws.com", "eventName": "AttachUserPolicy", "awsRegion": "us-east-1", "requestParameters": {"policyArn": "arn:aws:iam::aws:policy/AdministratorAccess", "userName": "temp-dev"}}',
  },
  {
    id: 'ALERT-005',
    timestamp: generateTimestamp(1),
    sourceSystem: 'EDR',
    eventType: 'Powershell Execution without Arguments',
    description: 'A suspicious PowerShell command was executed on "FINANCE-PC-05".',
    severity: 'Medium',
    rawLogSnippet: '{"timestamp": "...", "process": "powershell.exe", "command_line": "powershell -enc aW52b2tl...", "parent_process": "explorer.exe"}',
    behavioralContextSummary: 'This user in the finance department rarely uses PowerShell.',
  },
  {
    id: 'ALERT-006',
    timestamp: generateTimestamp(1),
    sourceSystem: 'EDR',
    eventType: 'Process Created from Word',
    description: 'WINWORD.EXE created a new process: cmd.exe',
    severity: 'High',
    rawLogSnippet: '{"timestamp":"...", "parent_process":"WINWORD.EXE", "child_process":"cmd.exe"}',
  },
];

export const mockIncidents: Incident[] = [
  {
    id: 'INC-001',
    summary: 'Potential Ransomware Attack on FINANCE-PC-05',
    attackChain: '1. User opened a malicious Word document. 2. Word spawned a command shell. 3. PowerShell was used to download and execute malware. 4. Malware began encrypting files and attempted to spread.',
    severity: 'Critical',
    correlatedEvents: [
      'ALERT-002: Malware Detected',
      'ALERT-005: Powershell Execution',
      'ALERT-006: Process Created from Word',
    ],
    alerts: [mockAlerts[1], mockAlerts[4], mockAlerts[5]],
  },
  {
    id: 'INC-002',
    summary: 'Possible Data Exfiltration from Production Database',
    attackChain: '1. Attacker gained access via multiple failed logins. 2. Unusual outbound traffic detected from the database server.',
    severity: 'High',
    correlatedEvents: [
      'ALERT-001: Multiple Failed Login Attempts',
      'ALERT-003: Unusual Outbound Traffic',
    ],
    alerts: [mockAlerts[0], mockAlerts[2]],
  },
];

export const mockPlaybookEffectivenessData: PlaybookEffectiveness[] = [
    { date: "Wk 1", effectiveness: 4.1 },
    { date: "Wk 2", effectiveness: 4.3 },
    { date: "Wk 3", effectiveness: 4.2 },
    { date: "Wk 4", effectiveness: 4.4 },
    { date: "Wk 5", effectiveness: 4.6 },
    { date: "Wk 6", effectiveness: 4.7 },
];
