export type Severity = "Low" | "Medium" | "High" | "Critical";

export type Alert = {
  id: string;
  timestamp: string;
  sourceSystem: string;
  eventType: string;
  description: string;
  severity: Severity;
  rawLogSnippet: string;
  anomalyDetectionSummary?: string;
  behavioralContextSummary?: string;
};

export type Incident = {
  id: string;
  summary: string;
  attackChain: string;
  severity: Severity;
  correlatedEvents: string[];
  alerts: Alert[];
};

export type PlaybookStep = {
  stepNumber: number;
  description: string;
  details: string;
  remediationAction: boolean;
};

export type ExpertPersona = "Dr. Sarah Chen" | "Marcus Okonkwo";

export type Playbook = {
  playbookTitle: string;
  severity: Severity;
  steps: PlaybookStep[];
  advisedBy: ExpertPersona;
  expertReasoning: string;
};

export type FidelityCommitteeVote = {
  model: string;
  vote: 'Malicious' | 'Benign' | 'Uncertain';
  confidence: number;
}

export type AlertFidelityRanking = {
  fidelityScore: number;
  severity: Severity;
  reasoning: string;
  recommendedAction: string;
  committee: FidelityCommitteeVote[];
}

export type PlaybookEffectiveness = {
    date: string;
    effectiveness: number;
}
