'use client';
import { useState } from 'react';
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from '@/components/ui/table';
import {
  Card,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
} from '@/components/ui/card';
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
  DialogDescription,
} from '@/components/ui/dialog';
import { Button } from '@/components/ui/button';
import { Progress } from '@/components/ui/progress';
import { Skeleton } from '@/components/ui/skeleton';
import { Separator } from '@/components/ui/separator';
import { mockAlerts } from '@/lib/data';
import { SeverityBadge } from '@/components/severity-badge';
import type { Alert } from '@/lib/types';
import { rankAlertFidelity } from '@/lib/actions';
import type { AlertFidelityRankingOutput } from '@/ai/flows/ai-powered-alert-fidelity-ranking';
import { formatDistanceToNow } from 'date-fns';
import { FileText, Wand2, CheckCircle2, XCircle, HelpCircle } from 'lucide-react';
import { useToast } from '@/hooks/use-toast';
import { Badge } from '@/components/ui/badge';
import {
  Tooltip,
  TooltipContent,
  TooltipProvider,
  TooltipTrigger,
} from '@/components/ui/tooltip';

const voteIcon = (vote: 'Malicious' | 'Benign' | 'Uncertain') => {
  switch (vote) {
    case 'Malicious':
      return <XCircle className="h-5 w-5 text-destructive" />;
    case 'Benign':
      return <CheckCircle2 className="h-5 w-5 text-green-500" />;
    case 'Uncertain':
      return <HelpCircle className="h-5 w-5 text-muted-foreground" />;
  }
};


export default function AlertsPage() {
  const [selectedAlert, setSelectedAlert] = useState<Alert | null>(null);
  const [ranking, setRanking] = useState<AlertFidelityRankingOutput | null>(null);
  const [isLoading, setIsLoading] = useState(false);
  const { toast } = useToast();

  const handleViewDetails = (alert: Alert) => {
    setSelectedAlert(alert);
    setRanking(null);
  };

  const handleRankFidelity = async () => {
    if (!selectedAlert) return;

    setIsLoading(true);
    try {
      const result = await rankAlertFidelity({
        alertId: selectedAlert.id,
        timestamp: selectedAlert.timestamp,
        sourceSystem: selectedAlert.sourceSystem,
        eventType: selectedAlert.eventType,
        description: selectedAlert.description,
        rawLogSnippet: selectedAlert.rawLogSnippet,
        anomalyDetectionSummary: selectedAlert.anomalyDetectionSummary,
        behavioralContextSummary: selectedAlert.behavioralContextSummary,
      });
      setRanking(result);
    } catch (error) {
      console.error('Error ranking fidelity:', error);
      toast({
        variant: 'destructive',
        title: 'Error',
        description: 'Failed to get AI-powered ranking.',
      });
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <TooltipProvider>
      <Card>
        <CardHeader>
          <CardTitle className="font-headline">All Security Alerts</CardTitle>
          <CardDescription>
            Browse and analyze all ingested security alerts from your connected systems.
          </CardDescription>
        </CardHeader>
        <CardContent>
          <Table>
            <TableHeader>
              <TableRow>
                <TableHead>Alert ID</TableHead>
                <TableHead>Timestamp</TableHead>
                <TableHead>Source</TableHead>
                <TableHead>Event Type</TableHead>
                <TableHead>Severity</TableHead>
                <TableHead className="text-right">Actions</TableHead>
              </TableRow>
            </TableHeader>
            <TableBody>
              {mockAlerts.map((alert) => (
                <TableRow key={alert.id}>
                  <TableCell className="font-medium">{alert.id}</TableCell>
                  <TableCell>
                    {formatDistanceToNow(new Date(alert.timestamp), { addSuffix: true })}
                  </TableCell>
                  <TableCell>{alert.sourceSystem}</TableCell>
                  <TableCell>{alert.eventType}</TableCell>
                  <TableCell>
                    <SeverityBadge severity={alert.severity} />
                  </TableCell>
                  <TableCell className="text-right">
                    <Button
                      variant="outline"
                      size="sm"
                      onClick={() => handleViewDetails(alert)}
                    >
                      View Details
                    </Button>
                  </TableCell>
                </TableRow>
              ))}
            </TableBody>
          </Table>
        </CardContent>
      </Card>

      <Dialog open={!!selectedAlert} onOpenChange={(open) => !open && setSelectedAlert(null)}>
        <DialogContent className="sm:max-w-3xl">
          <DialogHeader>
            <DialogTitle className="font-headline">
              Alert Details: {selectedAlert?.id}
            </DialogTitle>
            <DialogDescription>
              {selectedAlert?.description}
            </DialogDescription>
          </DialogHeader>
          <div className="grid gap-6 py-4">
            <div className="flex items-start gap-4">
              <FileText className="h-6 w-6 text-muted-foreground mt-1" />
              <div className="grid gap-1">
                <h3 className="font-semibold">Raw Log</h3>
                <pre className="mt-2 rounded-md bg-muted p-4 text-xs overflow-auto max-h-48">
                  <code>{JSON.stringify(JSON.parse(selectedAlert?.rawLogSnippet || '{}'), null, 2)}</code>
                </pre>
              </div>
            </div>
            <Separator />
            <div className="flex items-start gap-4">
              <Wand2 className="h-6 w-6 text-primary mt-1" />
              <div className="grid gap-1 w-full">
                <h3 className="font-semibold">AI-Powered Fidelity Ranking</h3>
                {!ranking && !isLoading && (
                  <Button onClick={handleRankFidelity} className="mt-2">
                    <Wand2 className="mr-2" />
                    Run Fidelity Analysis
                  </Button>
                )}
                {isLoading && (
                  <div className="space-y-2 mt-2">
                    <Skeleton className="h-4 w-1/4" />
                    <Skeleton className="h-8 w-full" />
                    <Skeleton className="h-4 w-3/4" />
                  </div>
                )}
                {ranking && (
                  <div className="grid gap-4 mt-2">
                    <div className="flex flex-col sm:flex-row gap-4 sm:items-center sm:justify-between rounded-lg border p-4">
                       <div>
                          <label className="text-sm font-medium">Consensus Fidelity Score</label>
                          <p className="text-3xl font-bold">{ranking.fidelityScore}%</p>
                       </div>
                        <div className="w-full sm:w-auto">
                          <label className="text-sm font-medium">Assigned Severity</label>
                          <div><SeverityBadge severity={ranking.severity as any} /></div>
                        </div>
                    </div>
                    <div>
                      <h4 className="text-sm font-medium">Reasoning</h4>
                      <p className="text-sm text-muted-foreground">{ranking.reasoning}</p>
                    </div>
                     <div>
                      <h4 className="text-sm font-medium mb-2">Fidelity Committee Votes</h4>
                      <div className="grid grid-cols-2 sm:grid-cols-3 lg:grid-cols-5 gap-2 text-center">
                        {ranking.committee.map(model => (
                          <Tooltip key={model.model}>
                            <TooltipTrigger asChild>
                              <div className='flex flex-col items-center justify-center gap-1 rounded-md border p-2'>
                                {voteIcon(model.vote)}
                                <p className='text-xs font-medium truncate w-full'>{model.model}</p>
                                <Badge variant="secondary" className='text-xs'>{(model.confidence * 100).toFixed(0)}%</Badge>
                              </div>
                            </TooltipTrigger>
                             <TooltipContent>
                              <p>{model.vote} ({(model.confidence * 100).toFixed(0)}% confidence)</p>
                            </TooltipContent>
                          </Tooltip>
                        ))}
                      </div>
                    </div>
                    <div>
                      <h4 className="text-sm font-medium">Recommended Action</h4>
                      <p className="text-sm text-muted-foreground bg-muted p-3 rounded-md">{ranking.recommendedAction}</p>
                    </div>
                  </div>
                )}
              </div>
            </div>
          </div>
        </DialogContent>
      </Dialog>
    </TooltipProvider>
  );
}

