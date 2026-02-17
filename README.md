<img width="1410" height="454" alt="image" src="https://github.com/user-attachments/assets/0b037ce2-7ce1-46d9-ac19-e070ea7ad20f" /><img width="15421" height="4990" alt="deepseek_mermaid_20260217_af9b1f" src="https://github.com/user-attachments/assets/b1442671-7c37-4f96-a4d3-4134b4615eb2" />CyberMind - AI-Powered Security Operations Center (SOC) Platform

🚀 Overview
CyberMind is an innovative AI-powered Security Operations Center (SOC) platform designed for MKSSS's Cummins College of Engineering for Women, Pune, in collaboration with Barclays. The platform leverages cutting-edge AI to transform how security analysts detect, investigate, and respond to cybersecurity threats.

🎯 Key Innovation
CyberMind introduces the concept of "Expert Twins" - AI agents that encapsulate the decision-making logic of senior threat analysts. These digital twins guide junior analysts through complex security incidents, ensuring enterprise-grade expertise is available 24/7 across the entire team.

✨ Features
1. AI-Powered Alert Fidelity Ranking
Multi-model ensemble ("Fidelity Committee") evaluates security alerts

Models include Isolation Forest, LOF, Behavioral Baseline, Pattern Matcher, and Local Threat Intel

Provides consensus-driven confidence scores and severity classification

Reduces false positives through collective intelligence

2. Automated Incident Response Playbooks
Generates contextual, step-by-step response plans for security incidents

Two expert personas available:

Dr. Sarah Chen: Compliance-focused, methodical approach

Marcus Okonkwo: Aggressive containment, APT hunter mentality

Real-time adaptation based on analyst feedback

3. Living Playbooks with Feedback Loop
Analysts can rate playbook effectiveness (1-5 stars)

System learns from feedback to improve future recommendations

Continuous improvement of response quality over time

4. Data Sovereignty & Compliance Tracker
100% air-gapped operation with zero external data transfer

Built-in compliance monitoring (GDPR, PCI-DSS, SOX)

Visual assurance that all data remains within private network

5. MTTR Savings Calculator
Real-time calculation of time and cost savings

Manual vs. AI-assisted response time comparison

Demonstrates ROI of AI-powered automation

6. Innovative SOC Concepts
UEBA Behavioral Heatmap: Visual anomaly detection

Federated Cross-Bank Learning: Collaborative threat intelligence without data sharing

Immersive Security Operations (AR/VR): Future-forward 3D threat visualization

🛠️ Technology Stack
Frontend: Next.js 14 (App Router), React, TypeScript

UI Components: shadcn/ui, Tailwind CSS

AI/ML: Google Genkit, Custom AI Flows

Data Visualization: Recharts
🛠️ Technology Stack
Frontend: Next.js 14 (App Router), React, TypeScript

UI Components: shadcn/ui, Tailwind CSS

AI/ML: Google Genkit, Custom AI Flows

Data Visualization: Recharts

State Management: React Hooks, Context API

Type Safety: TypeScript, Zod Schemas

State Management: React Hooks, Context API

Type Safety: TypeScript, Zod Schemas

cybermind/
├── src/
│   ├── app/
│   │   └── (app)/
│   │       ├── dashboard/        # Main dashboard with KPI cards
│   │       ├── alerts/            # Alert management & fidelity ranking
│   │       └── incidents/         # Incident details & playbook generation
│   ├── ai/
│   │   └── flows/
│   │       ├── ai-powered-alert-fidelity-ranking.ts    # Alert scoring AI
│   │       └── automated-incident-playbook-generation.ts # Playbook AI
│   ├── components/                 # Reusable UI components
│   ├── lib/
│   │   ├── types.ts                # TypeScript type definitions
│   │   ├── data.ts                 # Mock data for development
│   │   └── actions.ts              # Server actions
│   └── hooks/                       # Custom React hooks
├── public/
│   └── map.svg                      # World map visualization
└── [configuration files]
<img width="1410" height="454" alt="image" src="https://github.com/user-attachments/assets/f4eeb0dd-8ff6-44ed-b411-592581153127" />







💡 Key Workflows
Alert Triage Process
Ingestion: Security alerts flow into the system from various sources (SIEM, EDR, Firewall)

Fidelity Committee: Multi-model AI ensemble evaluates each alert

Scoring: Alerts receive fidelity scores (0-100) and severity classification

Context: AI provides reasoning and recommended actions

Incident Response
Correlation: Related alerts are grouped into incidents

Playbook Generation: AI creates contextual response plans based on expert persona

Execution: Analysts follow step-by-step guidance

Feedback: Rating system improves future playbooks

📊 Dashboard Metrics
Total Alerts: Overview of alert volume (last 7 days)

Critical Incidents: High-priority incidents requiring immediate attention

Playbooks Generated: Number of automated response plans created

MTTR Savings: Real-time calculation of time and cost saved

Data Sovereignty: Visual assurance of air-gapped operation

🧪 Development Features
Mock data system for development and testing

Type-safe AI flow inputs/outputs with Zod schemas

Responsive design for all screen sizes

Toast notifications for user feedback

Loading skeletons for better UX

🔮 Future Innovations
AR/VR Integration: 3D visualization of security infrastructure

Federated Learning: Collaborative threat detection across institutions

Advanced UEBA: Behavioral analytics with peer group comparison

Automated Threat Hunting: Proactive threat detection algorithms

🤝 Contributing
This project is developed as part of the Barclays collaboration with MKSSS's Cummins College of Engineering for Women, Pune. For internal contribution guidelines, please refer to the project documentation.

📝 License
This project is proprietary and confidential. Unauthorized copying, distribution, or use is strictly prohibited.

👥 Team
Shreya Chobhe - Developer
Siddhi Agrawal - Developer
Anushka Gite - Developer
Mrunal Baravkar -Developer
Nidhi Bijwani - Developer

🙏 Acknowledgments
Barclays for mentorship and industry guidance

MKSSS's Cummins College of Engineering for Women, Pune for institutional support

All contributors and testers who provided valuable feedback

CyberMind: Transforming Security Operations Through Collective Intelligence 🔒✨
