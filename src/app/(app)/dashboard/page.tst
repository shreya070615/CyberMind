'use client';

import {
  Card,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
} from '@/components/ui/card';
import {
  ChartContainer,
  ChartTooltip,
  ChartTooltipContent,
} from '@/components/ui/chart';
import { mockAlerts, mockIncidents, mockPlaybookEffectivenessData } from '@/lib/data';
import { Bar, BarChart, CartesianGrid, XAxis, YAxis, Line, LineChart, Tooltip } from 'recharts';
import {
  FileWarning,
  ShieldAlert,
  BookOpen,
  Lock,
  Timer,
  BrainCircuit,
  TrendingUp,
  ShieldCheck,
  Gauge,
  Users,
  GitBranch,
  Eye,
  Share2,
  Box,
  DollarSign,
  Clock,
  Zap,
} from 'lucide-react';
import { useMemo } from 'react';
import type { Severity } from '@/lib/types';
import { Badge } from '@/components/ui/badge';
import Image from 'next/image';

const alertsChartConfig = {
  count: {
    label: 'Count',
  },
  Critical: {
    label: 'Critical',
    color: 'hsl(var(--destructive))',
  },
  High: {
    label: 'High',
    color: 'hsl(var(--primary))',
  },
  Medium: {
    label: 'Medium',
    color: 'hsl(var(--secondary-foreground))',
  },
  Low: {
    label: 'Low',
    color: 'hsl(var(--muted-foreground))',
  },
};

const playbookChartConfig = {
  effectiveness: {
    label: "Effectiveness",
    color: "hsl(var(--primary))",
  },
} 

const DataSovereigntyTracker = () => (
  <Card className="col-span-full lg:col-span-1">
    <CardHeader>
      <div className="flex items-center gap-2">
        <ShieldCheck className="h-6 w-6 text-green-500" />
        <CardTitle className="font-headline text-lg">Data Sovereignty & Compliance</CardTitle>
      </div>
    </CardHeader>
    <CardContent className="space-y-4">
      <div className="flex items-center justify-between rounded-lg bg-muted p-3">
        <div className="font-medium">External API Calls</div>
        <div className="font-bold text-green-500 text-2xl">0</div>
      </div>
       <div className='relative'>
        <Image src="/map.svg" alt="World map" width={500} height={250} className='opacity-20' />
        <div className='absolute inset-0 flex items-center justify-center'>
            <div className='p-3 bg-background/80 rounded-lg text-center'>
                <p className='font-bold text-primary'>Processing Zone</p>
                <p className='text-xs text-muted-foreground'>All data remains within your private network.</p>
            </div>
        </div>
      </div>
      <div className="text-center">
        <Badge className="bg-green-100 text-green-800 border-green-300">
          <Lock className="mr-1" /> 100% AIR-GAPPED | ZERO EXTERNAL DATA TRANSFER
        </Badge>
      </div>
      <div className="flex justify-center gap-2">
        <Badge variant="secondary" className="border-green-500 text-green-600">GDPR</Badge>
        <Badge variant="secondary" className="border-green-500 text-green-600">PCI-DSS</Badge>
        <Badge variant="secondary" className="border-green-500 text-green-600">SOX</Badge>
      </div>
    </CardContent>
  </Card>
);

const MttrSavingsCalculator = () => {
    const incidentsAccelerated = mockIncidents.length;
    const manualResponseTime = 65; // minutes
    const agentResponseTime = 2.5; // minutes
    const timeSavedPerIncident = manualResponseTime - agentResponseTime;
    const totalTimeSaved = incidentsAccelerated * timeSavedPerIncident;
    const costPerHour = 150;
    const costSaved = (totalTimeSaved / 60) * costPerHour;

    return (
        <Card className="col-span-full lg:col-span-2">
             <CardHeader>
                <div className="flex items-center gap-2">
                    <Gauge className="h-6 w-6 text-primary" />
                    <CardTitle className="font-headline text-lg">MTTR Savings Calculator</CardTitle>
                </div>
            </CardHeader>
            <CardContent className="grid grid-cols-2 md:grid-cols-4 gap-4 text-center">
                <div className="rounded-lg bg-muted p-4">
                    <p className="text-sm text-muted-foreground">Manual MTTR</p>
                    <p className="text-2xl font-bold">{manualResponseTime} <span className="text-base font-normal">min</span></p>
                </div>
                 <div className="rounded-lg bg-muted p-4">
                    <p className="text-sm text-muted-foreground">Agent MTTR</p>
                    <p className="text-2xl font-bold text-primary">{agentResponseTime} <span className="text-base font-normal">min</span></p>
                </div>
                <div className="rounded-lg bg-muted p-4 col-span-2 md:col-span-1">
                    <p className="text-sm text-muted-foreground">Incidents Accelerated</p>
                    <p className="text-2xl font-bold">{incidentsAccelerated}</p>
                </div>
                 <div className="rounded-lg bg-primary text-primary-foreground p-4 col-span-2 md:col-span-1">
                    <p className="text-sm opacity-80">Total Savings</p>
                    <p className="text-2xl font-bold">${costSaved.toLocaleString()}</p>
                </div>
                
                <div className="col-span-full grid grid-cols-2 gap-4">
                     <div className="flex items-center gap-3 p-4 rounded-lg bg-muted">
                        <Clock className="h-6 w-6 text-muted-foreground" />
                        <div>
                            <p className="text-sm text-muted-foreground">Time Saved This Week</p>
                            <p className="font-bold text-lg">{totalTimeSaved} minutes</p>
                        </div>
                    </div>
                     <div className="flex items-center gap-3 p-4 rounded-lg bg-muted">
                        <DollarSign className="h-6 w-6 text-muted-foreground" />
                        <div>
                            <p className="text-sm text-muted-foreground">Cost Saved (at ${costPerHour}/hr)</p>
                            <p className="font-bold text-lg">${costSaved.toLocaleString()}</p>
                        </div>
                    </div>
                </div>
            </CardContent>
        </Card>
    );
};

const InnovationCard = ({ icon, title, description }: { icon: React.ReactNode, title: string, description: string }) => (
    <Card className="flex flex-col">
        <CardHeader>
            <div className="flex items-start justify-between gap-4">
                <CardTitle className="text-lg font-semibold">{title}</CardTitle>
                <div className="text-muted-foreground flex-shrink-0">{icon}</div>
            </div>
        </CardHeader>
        <CardContent className="flex-grow">
            <p className="text-sm text-muted-foreground">
                {description}
            </p>
        </CardContent>
    </Card>
)

export default function DashboardPage() {
  const totalAlerts = mockAlerts.length;
  const criticalIncidents = mockIncidents.filter(
    (i) => i.severity === 'Critical'
  ).length;

  const alertsBySeverity = useMemo(() => {
    const counts: Record<Severity, number> = {
      Critical: 0,
      High: 0,
      Medium: 0,
      Low: 0,
    };
    mockAlerts.forEach((alert) => {
      counts[alert.severity]++;
    });
    return [
      { severity: 'Low', count: counts.Low, fill: 'var(--color-Low)' },
      { severity: 'Medium', count: counts.Medium, fill: 'var(--color-Medium)' },
      { severity: 'High', count: counts.High, fill: 'var(--color-High)' },
      {
        severity: 'Critical',
        count: counts.Critical,
        fill: 'var(--color-Critical)',
      },
    ];
  }, []);

  return (
    <div className="flex flex-col gap-6">
      <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-3">
        <Card>
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-sm font-medium">Total Alerts</CardTitle>
            <ShieldAlert className="h-4 w-4 text-muted-foreground" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold">{totalAlerts}</div>
            <p className="text-xs text-muted-foreground">in the last 7 days</p>
          </CardContent>
        </Card>
        <Card>
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-sm font-medium">
              Critical Incidents
            </CardTitle>
            <FileWarning className="h-4 w-4 text-destructive" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold">{criticalIncidents}</div>
            <p className="text-xs text-muted-foreground">require immediate attention</p>
          </CardContent>
        </Card>
        <Card>
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-sm font-medium">
              Playbooks Generated
            </CardTitle>
            <BookOpen className="h-4 w-4 text-muted-foreground" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold">
              {mockIncidents.length}
            </div>
            <p className="text-xs text-muted-foreground">
              automated response plans created
            </p>
          </CardContent>
        </Card>
      </div>

       <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
          <DataSovereigntyTracker />
          <MttrSavingsCalculator />
       </div>

      <div className="grid gap-6 md:grid-cols-2">
        <Card>
            <CardHeader>
            <CardTitle className="font-headline">Alerts by Severity</CardTitle>
            <CardDescription>
                A summary of security alerts over the past week.
            </CardDescription>
            </CardHeader>
            <CardContent>
            <ChartContainer config={alertsChartConfig} className="h-64 w-full">
                <BarChart
                accessibilityLayer
                data={alertsBySeverity}
                margin={{ top: 20, right: 20, bottom: 20, left: 20 }}
                >
                <CartesianGrid vertical={false} />
                <XAxis
                    dataKey="severity"
                    tickLine={false}
                    tickMargin={10}
                    axisLine={false}
                />
                <YAxis />
                <ChartTooltip
                    cursor={false}
                    content={<ChartTooltipContent indicator="dot" />}
                />
                <Bar dataKey="count" radius={8} />
                </BarChart>
            </ChartContainer>
            </CardContent>
        </Card>
        <Card>
            <CardHeader>
                <CardTitle className="font-headline">Living Playbook Effectiveness</CardTitle>
                <CardDescription>
                Analyst feedback is used to automatically improve playbooks over time.
                </CardDescription>
            </CardHeader>
            <CardContent>
                <ChartContainer config={playbookChartConfig} className="h-64 w-full">
                <LineChart
                    accessibilityLayer
                    data={mockPlaybookEffectivenessData}
                    margin={{
                    top: 20,
                    right: 20,
                    bottom: 20,
                    left: 20,
                    }}
                >
                    <CartesianGrid vertical={false} />
                    <XAxis
                    dataKey="date"
                    tickLine={false}
                    axisLine={false}
                    tickMargin={8}
                    />
                    <YAxis domain={[3, 5]}/>
                    <Tooltip
                    content={<ChartTooltipContent />}
                    />
                    <Line
                    dataKey="effectiveness"
                    type="monotone"
                    stroke="var(--color-effectiveness)"
                    strokeWidth={2}
                    dot={{
                        fill: "var(--color-effectiveness)",
                    }}
                    activeDot={{
                        r: 6,
                    }}
                    />
                </LineChart>
                </ChartContainer>
            </CardContent>
        </Card>
      </div>

      <div className="mt-6">
        <h2 className="font-headline text-2xl font-bold mb-4">CyberMind Innovations</h2>
        <div className="grid gap-6 md:grid-cols-2 lg:grid-cols-3">
             <InnovationCard 
                icon={<Timer className="h-8 w-8" />}
                title="The 3-Minute Triage"
                description="By reducing 6 raw alerts to 1 critical incident and providing an expert playbook, our agent cuts Mean-Time-to-Respond (MTTR) from over an hour to under 3 minutes, directly limiting financial and reputational damage."
            />
            <InnovationCard
                icon={<BrainCircuit className="h-8 w-8" />}
                title='"Expert Twin" Knowledge Preservation'
                description="Senior threat analysts' decision-making logic is encoded into every playbook. When a junior analyst responds, they are guided by the expertise of your best, ensuring consistency and excellence across the entire global team, 24/7."
            />
            <InnovationCard
                icon={<TrendingUp className="h-8 w-8" />}
                title="Adaptive to Modern Banking Threats"
                description="Our backend is specifically tuned to detect anomalies in banking transaction flows. This helps identify novel fraud patterns and Business Email Compromise (BEC) campaigns that rule-based systems miss, keeping you ahead of modern threats."
            />
            <InnovationCard
                icon={<Users className="h-8 w-8" />}
                title="Fidelity Committee"
                description="A multi-model ensemble (Isolation Forest, LOF, etc.) votes on alert fidelity. This consensus mechanism increases accuracy and provides a confidence score, flagging disagreements for human review."
            />
            <InnovationCard
                icon={<Eye className="h-8 w-8" />}
                title="UEBA Behavioral Heatmap"
                description="Visually compare individual user behavior against their own baseline and their peer group. Deviation scores and a confidence meter are plotted on an interactive heatmap to instantly spot anomalies."
            />
             <InnovationCard
                icon={<GitBranch className="h-8 w-8" />}
                title="Living Playbooks with Feedback"
                description="A closed feedback loop allows analysts to rate playbook effectiveness. The system learns from this feedback, finetuning future playbook generation to become more effective over time."
            />
            <InnovationCard
                icon={<Share2 className="h-8 w-8" />}
                title="Federated Cross-Bank Learning"
                description="Anonymously share threat model updates—not data—with other institutions. This allows for collaborative defense against emerging threats without ever compromising customer PII, creating a powerful network effect."
            />
            <InnovationCard
                icon={<Box className="h-8 w-8" />}
                title="Immersive Security Operations (AR/VR)"
                description="A forward-looking concept for a 3D visualization of your global infrastructure. Analysts in AR can 'grab' threats, inspect them, and execute containment actions with intuitive gestures, revolutionizing the SOC."
            />
        </div>
      </div>
    </div>
  );
}
