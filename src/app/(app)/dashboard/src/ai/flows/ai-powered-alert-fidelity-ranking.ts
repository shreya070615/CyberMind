'use server';
/**
 * @fileOverview An AI agent for ranking the fidelity and severity of security alerts.
 *
 * - rankAlertFidelity - A function that handles the alert fidelity ranking process.
 * - AlertFidelityRankingInput - The input type for the rankAlertFidelity function.
 * - AlertFidelityRankingOutput - The return type for the rankAlertFidelity function.
 */

import { ai } from '@/ai/genkit';
import { z } from 'genkit';

const AlertFidelityRankingInputSchema = z.object({
  alertId: z.string().describe('Unique identifier for the security alert.'),
  timestamp: z.string().describe('Timestamp when the alert occurred (e.g., ISO 8601 format).'),
  sourceSystem: z.string().describe('The system that generated the alert (e.g., SIEM, EDR, Firewall).'),
  eventType: z.string().describe('The type of security event that triggered the alert (e.g., "Failed Login Attempt", "Malware Detected").'),
  description: z.string().describe('A detailed description of the security alert.'),
  rawLogSnippet: z.string().optional().describe('A snippet of the raw log data associated with the alert.'),
  anomalyDetectionSummary: z.string().optional().describe('A summary of any anomaly detection results related to this alert, e.g., "Unusual login time for user X", "High volume of outbound traffic".'),
  behavioralContextSummary: z.string().optional().describe('A summary of behavioral analytics context, e.g., "User X typically logs in from Y during business hours", "Server Z usually communicates only with internal network A".'),
});
export type AlertFidelityRankingInput = z.infer<typeof AlertFidelityRankingInputSchema>;

const AlertFidelityRankingOutputSchema = z.object({
  fidelityScore: z.number().min(0).max(100).describe('A score from 0-100 indicating the confidence in the alert being a true positive. Higher is better.'),
  severity: z.enum(['Critical', 'High', 'Medium', 'Low']).describe('The severity of the alert, categorized as Critical, High, Medium, or Low.'),
  reasoning: z.string().describe('A concise explanation for the assigned fidelity score and severity.'),
  recommendedAction: z.string().describe('A high-level recommended next step for a security analyst.'),
  committee: z.array(z.object({
    model: z.string().describe('The name of the analysis model.'),
    vote: z.enum(['Malicious', 'Benign', 'Uncertain']).describe('The vote of the model.'),
    confidence: z.number().min(0).max(1).describe('The confidence of the model in its vote.'),
  })).describe('The votes from the "Fidelity Committee" of different analysis models.'),
});
export type AlertFidelityRankingOutput = z.infer<typeof AlertFidelityRankingOutputSchema>;

export async function rankAlertFidelity(input: AlertFidelityRankingInput): Promise<AlertFidelityRankingOutput> {
  return alertFidelityRankingFlow(input);
}

const prompt = ai.definePrompt({
  name: 'alertFidelityRankingPrompt',
  input: { schema: AlertFidelityRankingInputSchema },
  output: { schema: AlertFidelityRankingOutputSchema },
  prompt: `You are an expert security analyst meta-model, leading a "Fidelity Committee" to evaluate security alerts.
Your committee consists of 5 specialist models:
1. Isolation Forest (Detects outliers in high-dimensional data)
2. Local Outlier Factor (LOF) (Identifies anomalies based on local density)
3. Behavioral Baseline (Compares activity against historical user/entity behavior)
4. Pattern Matcher (Looks for known malicious signatures and IOCs)
5. Local Threat Intel (Cross-references with an internal threat intelligence database)

Your task is to synthesize a final judgment based on the alert data and the (simulated) outputs of your committee.

Consider the following security alert details:

Alert ID: {{{alertId}}}
Timestamp: {{{timestamp}}}
Source System: {{{sourceSystem}}}
Event Type: {{{eventType}}}
Description: {{{description}}}

{{#if rawLogSnippet}}
Raw Log Snippet: {{{rawLogSnippet}}}
{{/if}}

{{#if anomalyDetectionSummary}}
Anomaly Detection Summary: {{{anomalyDetectionSummary}}}
{{/if}}

{{#if behavioralContextSummary}}
Behavioral Context Summary: {{{behavioralContextSummary}}}
{{/if}}

Based on all available information, perform the following:
1.  **Simulate Votes:** For each of the 5 committee models, determine a logical vote ('Malicious', 'Benign', 'Uncertain') and a confidence score (0.0 to 1.0). For example, if the behavioral summary shows a strong deviation, the 'Behavioral Baseline' model should vote 'Malicious' with high confidence. If there's no known pattern, 'Pattern Matcher' might vote 'Uncertain'.
2.  **Analyze Consensus:** Evaluate the agreement level among the models.
3.  **Assign Final Score & Severity:** Based on the committee's consensus (or lack thereof), determine a final 'fidelityScore' (0-100) and 'severity' (Critical, High, Medium, Low). High agreement on 'Malicious' should result in a high score and severity. Disagreement should lower the score.
4.  **Provide Reasoning:** Explain *why* you reached your conclusion, referencing the committee's votes. E.g., "The high fidelity score is driven by strong agreement from the Behavioral and LOF models, despite the Pattern Matcher finding no known signature."
5.  **Recommend Action:** Suggest a concise next step for a human analyst.

Generate the full response in the required JSON format.`,
});

const alertFidelityRankingFlow = ai.defineFlow(
  {
    name: 'alertFidelityRankingFlow',
    inputSchema: AlertFidelityRankingInputSchema,
    outputSchema: AlertFidelityRankingOutputSchema,
  },
  async (input) => {
    const { output } = await prompt(input);
    return output!;
  },
);
