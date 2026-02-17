'use client';

import { useState } from 'react';
import { notFound } from 'next/navigation';
import { mockIncidents } from '@/lib/data';
import type { Playbook, ExpertPersona } from '@/lib/types';
import {
  Card,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
} from '@/components/ui/card';
import {
  Accordion,
  AccordionContent,
  AccordionItem,
  AccordionTrigger,
} from '@/components/ui/accordion';
import { Button } from '@/components/ui/button';
import { SeverityBadge } from '@/components/severity-badge';
import { Badge } from '@/components/ui/badge';
import { Separator } from '@/components/ui/separator';
import { Skeleton } from '@/components/ui/skeleton';
import { Wand2, Zap, CheckCircle, BrainCircuit, Star, UserCheck, UserX } from 'lucide-react';
import { generatePlaybook } from '@/lib/actions';
import { useToast } from '@/hooks/use-toast';
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import { Alert, AlertDescription, AlertTitle } from '@/components/ui/alert';

export default function IncidentDetailPage({
  params,
}: {
  params: { id: string };
}) {
  const incident = mockIncidents.find((i) => i.id === params.id);
  const [playbook, setPlaybook] = useState<Playbook | null>(null);
  const [isLoading, setIsLoading] = useState(false);
  const [selectedPersona, setSelectedPersona] = useState<ExpertPersona | null>(null);
  const [rating, setRating] = useState(0);
  const [feedbackSubmitted, setFeedbackSubmitted] = useState(false);

  const { toast } = useToast();

  if (!incident) {
    notFound();
  }

  const handleGeneratePlaybook = async () => {
    if (!selectedPersona) {
      toast({
        variant: 'destructive',
        title: 'Please select an expert persona',
        description: 'You must choose an expert to guide the playbook generation.',
      });
      return;
    }
    setIsLoading(true);
    try {
      const result = await generatePlaybook({
        incidentDescription: incident.summary,
        correlatedAlerts: incident.correlatedEvents,
        severity: incident.severity.toLowerCase() as any,
        affectedSystems: incident.alerts.map((a) => a.sourceSystem),
        expertPersona: selectedPersona,
      });
      setPlaybook(result as any);
      setRating(0);
      setFeedbackSubmitted(false);
      toast({
        title: 'Playbook Generated',
        description: `Generated with guidance from ${selectedPersona}.`,
      });
    } catch (error) {
      console.error('Error generating playbook:', error);
      toast({
        variant: 'destructive',
        title: 'Error',
        description: 'Failed to generate playbook.',
      });
    } finally {
      setIsLoading(false);
    }
  };

  const handleRating = (rate: number) => {
    setRating(rate);
    setFeedbackSubmitted(true);
    toast({
      title: 'Feedback Submitted',
      description: 'Thank you! Your feedback helps improve future playbooks.',
    });
  }

  return (
    <div className="grid gap-6 lg:grid-cols-3">
      <div className="lg:col-span-2 space-y-6">
        <Card>
          <CardHeader>
            <div className="flex items-center justify-between">
              <CardTitle className="font-headline">{incident.summary}</CardTitle>
              <SeverityBadge severity={incident.severity} />
            </div>
            <CardDescription>
              A step-by-step reconstruction of the identified attack.
            </CardDescription>
          </CardHeader>
          <CardContent>
            <div className="space-y-4">
              {incident.attackChain.split('. ').map((step, index) => (
                <div key={index} className="flex items-start gap-4">
                  <div className="flex h-8 w-8 items-center justify-center rounded-full bg-primary text-primary-foreground font-bold">
                    {index + 1}
                  </div>
                  <p className="pt-1">{step}</p>
                </div>
              ))}
            </div>
          </CardContent>
        </Card>
        <Card>
          <CardHeader>
            <CardTitle className="font-headline">Correlated Events</CardTitle>
            <CardDescription>
              The key alerts and events that make up this incident.
            </CardDescription>
          </CardHeader>
          <CardContent className="flex flex-wrap gap-2">
            {incident.correlatedEvents.map((event) => (
              <Badge key={event} variant="secondary">
                {event}
              </Badge>
            ))}
          </CardContent>
        </Card>
      </div>

      <div className="lg:col-span-1">
        <Card className="sticky top-20">
          <CardHeader>
            <CardTitle className="font-headline">Response Playbook</CardTitle>
            <CardDescription>
              Generate AI-guided steps for incident response.
            </CardDescription>
          </CardHeader>
          <CardContent className="space-y-4">
             <div>
                <label className="text-sm font-medium">Select Expert Persona</label>
                 <Select onValueChange={(value) => setSelectedPersona(value as ExpertPersona)} disabled={isLoading}>
                    <SelectTrigger className="w-full mt-1">
                        <SelectValue placeholder="Choose an expert twin..." />
                    </SelectTrigger>
                    <SelectContent>
                        <SelectItem value="Dr. Sarah Chen">
                            <div className="flex items-center gap-2">
                                <UserCheck className="text-blue-500" />
                                <div>
                                    <p>Dr. Sarah Chen</p>
                                    <p className="text-xs text-muted-foreground">Compliance-focused</p>
                                </div>
                            </div>
                        </SelectItem>
                        <SelectItem value="Marcus Okonkwo">
                             <div className="flex items-center gap-2">
                                <UserX className="text-red-500" />
                                <div>
                                    <p>Marcus Okonkwo</p>
                                    <p className="text-xs text-muted-foreground">Aggressive Containment</p>
                                </div>
                            </div>
                        </SelectItem>
                    </SelectContent>
                </Select>
             </div>

            {!playbook && !isLoading && (
              <Button onClick={handleGeneratePlaybook} className="w-full">
                <Wand2 className="mr-2" />
                Generate Playbook
              </Button>
            )}
            {isLoading && (
              <div className="space-y-4">
                <Skeleton className="h-10 w-full" />
                <Skeleton className="h-10 w-full" />
                <Skeleton className="h-10 w-full" />
              </div>
            )}
            {playbook && (
              <div>
                <Alert className="mb-4">
                  <BrainCircuit className="h-4 w-4" />
                  <AlertTitle>Advised by {playbook.advisedBy}</AlertTitle>
                  <AlertDescription>{playbook.expertReasoning}</AlertDescription>
                </Alert>
                <Accordion type="single" collapsible className="w-full">
                  {playbook.steps.map((step) => (
                    <AccordionItem key={step.stepNumber} value={`item-${step.stepNumber}`}>
                      <AccordionTrigger>
                        <div className="flex items-center gap-2 text-left">
                          {step.remediationAction ? (
                            <Zap className="h-4 w-4 text-accent-foreground flex-shrink-0" />
                          ) : (
                            <CheckCircle className="h-4 w-4 text-green-500 flex-shrink-0" />
                          )}
                          Step {step.stepNumber}: {step.description}
                        </div>
                      </AccordionTrigger>
                      <AccordionContent>
                        <p className="text-sm text-muted-foreground">{step.details}</p>
                      </AccordionContent>
                    </AccordionItem>
                  ))}
                </Accordion>
                <Separator className="my-4" />
                <div className="text-center">
                    <h4 className="text-sm font-medium mb-2">Was this playbook helpful?</h4>
                    {feedbackSubmitted ? (
                        <p className="text-sm text-green-600">Thank you for your feedback!</p>
                    ) : (
                        <div className="flex justify-center gap-1">
                        {[1, 2, 3, 4, 5].map((star) => (
                            <Star
                            key={star}
                            className={`cursor-pointer ${rating >= star ? 'text-yellow-400 fill-yellow-400' : 'text-gray-300'}`}
                            onClick={() => handleRating(star)}
                            />
                        ))}
                        </div>
                    )}
                </div>
              </div>
            )}
          </CardContent>
        </Card>
      </div>
    </div>
  );
}
