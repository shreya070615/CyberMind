'use server';
/**
 * @fileOverview This file implements a Genkit flow for automatically generating
 * step-by-step incident response playbooks based on detected security incidents.
 *
 * - generateAutomatedPlaybook - A function that triggers the playbook generation.
 * - AutomatedPlaybookGenerationInput - The input type for the generation process.
 * - AutomatedPlaybookGenerationOutput - The return type for the generated playbook.
 */

import { ai } from '@/ai/genkit';
import { z } from 'genkit';

const AutomatedPlaybookGenerationInputSchema = z.object({
  incidentDescription: z
    .string()
    .describe('A detailed description of the security incident.'),
  correlatedAlerts: z
    .array(z.string())
    .describe('A list of correlated security alerts that led to this incident.'),
  severity: z
    .enum(['low', 'medium', 'high', 'critical'])
    .describe('The severity of the incident.'),
  affectedSystems: z
    .array(z.string())
    .describe('A list of systems affected by the incident.'),
  expertPersona: z
    .enum(['Dr. Sarah Chen', 'Marcus Okonkwo'])
    .describe('The expert persona to guide playbook generation.'),
});
export type AutomatedPlaybookGenerationInput = z.infer<
  typeof AutomatedPlaybookGenerationInputSchema
>;

const AutomatedPlaybookGenerationOutputSchema = z.object({
  playbookTitle: z
    .string()
    .describe('The title of the generated incident response playbook.'),
  advisedBy: z
    .string()
    .describe('The name of the expert persona who advised this playbook.'),
  expertReasoning: z
    .string()
    .describe(
      'An expandable section explaining the high-level strategy behind the playbook, according to the chosen expert.'
    ),
  severity: z
    .enum(['low', 'medium', 'high', 'critical'])
    .describe('The severity of the incident.'),
  steps: z
    .array(
      z.object({
        stepNumber: z
          .number()
          .describe('The order of this step in the playbook.'),
        description: z
          .string()
          .describe('A high-level description of the action to be taken.'),
        details: z
          .string()
          .describe(
            'Detailed instructions or commands for performing this step.'
          ),
        remediationAction: z
          .boolean()
          .describe(
            'True if this step is a remediation action, false otherwise.'
          ),
      })
    )
    .describe('A step-by-step incident response playbook.'),
});
export type AutomatedPlaybookGenerationOutput = z.infer<
  typeof AutomatedPlaybookGenerationOutputSchema
>;

export async function generateAutomatedPlaybook(
  input: AutomatedPlaybookGenerationInput
): Promise<AutomatedPlaybookGenerationOutput> {
  return generateAutomatedPlaybookFlow(input);
}

const playbookGenerationPrompt = ai.definePrompt({
  name: 'playbookGenerationPrompt',
  input: { schema: AutomatedPlaybookGenerationInputSchema },
  output: { schema: AutomatedPlaybookGenerationOutputSchema },
  prompt: `You are an AI assistant that generates expert cybersecurity incident response playbooks. Your response will be guided by the persona of a selected "Expert Twin".

**Selected Expert Twin: {{{expertPersona}}}**

**Expert Personas:**
- **Dr. Sarah Chen (15yrs Fraud Detection):** Extremely risk-averse and compliance-focused. Prioritizes evidence preservation, documentation, and methodical isolation over speed. Prefers to avoid destructive actions unless absolutely necessary and after multiple confirmations. Her primary goal is ensuring regulatory compliance (like SOX, GDPR) is met and that every step is auditable.
- **Marcus Okonkwo (10yrs APT Hunter):** Favors aggressive and rapid containment. Believes in acting decisively to eject threats from the network, even if it means temporary service disruption. His priority is to minimize the threat's dwell time and prevent lateral movement at all costs. He is comfortable with disabling systems or blocking traffic first and asking questions later.

**Your Task:**
Generate a detailed, step-by-step incident response playbook based on the persona of **{{{expertPersona}}}**. The playbook must cover detection, containment, eradication, recovery, and post-incident analysis phases.

**Incident Details:**
- Description: {{{incidentDescription}}}
- Correlated Alerts: {{#each correlatedAlerts}}- {{{this}}}{{/each}}
- Severity: {{{severity}}}
- Affected Systems: {{#each affectedSystems}}- {{{this}}}{{/each}}

**Instructions:**
1.  **Adopt the Persona:** Write the entire playbook from the perspective of the selected expert. The tone, priorities, and types of steps should reflect their philosophy.
2.  **Expert Reasoning:** Begin with a section explaining the overall strategy. For Dr. Chen, this might be "Our primary objective is to contain the incident while meticulously preserving forensic evidence for regulatory review." For Marcus, it could be "Our immediate priority is to neutralize the threat and sever its access to our network to prevent further damage."
3.  **Generate Steps:** Create actionable, step-by-step instructions. Ensure 'remediationAction' is true for steps that directly fix the issue. The steps must align with the expert's approach (e.g., Dr. Chen would have more steps about taking forensic snapshots; Marcus would have more steps about immediate network isolation).
4.  **Format Output:** Generate the playbook in a JSON format matching the provided output schema. The 'advisedBy' field must be set to "{{{expertPersona}}}".
`,
});

const generateAutomatedPlaybookFlow = ai.defineFlow(
  {
    name: 'generateAutomatedPlaybookFlow',
    inputSchema: AutomatedPlaybookGenerationInputSchema,
    outputSchema: AutomatedPlaybookGenerationOutputSchema,
  },
  async (input) => {
    const { output } = await playbookGenerationPrompt(input);
    if (!output) {
      throw new Error('Failed to generate playbook output.');
    }
    return output;
  }
);

