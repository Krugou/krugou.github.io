import { TerritoryType, EventType, GameEvent, Territory } from "../models/types";
import territoryEventsData from "../data/events/territory_events.json";
import milestoneEventsData from "../data/events/milestone_events.json";

export interface EventTemplate {
  id: string;
  title: string;
  description: string;
  type: EventType;
  populationChange: number;
  probability: number;
  category: string;
  threshold?: number;
  trigger?: string;
  territoryType?: string;
}

// Asserting the imported JSON perfectly matches the template types
const territoryEvents: Record<string, EventTemplate[]> = territoryEventsData as any;
const milestoneEvents: EventTemplate[] = milestoneEventsData.milestones as any;

export const generateEventForTerritory = (territory: Territory): GameEvent | null => {
  const eventPool = territoryEvents[territory.type] || [];
  if (eventPool.length === 0) return null;

  for (const template of eventPool) {
    if (Math.random() < template.probability) {
      return createEventFromTemplate(template, territory);
    }
  }
  return null;
}

export const checkMilestoneEvent = (
  totalPopulation: number,
  achievedMilestones: string[]
): GameEvent | null => {
  for (const template of milestoneEvents) {
    if (
      template.threshold !== undefined &&
      totalPopulation >= template.threshold &&
      !achievedMilestones.includes(template.id)
    ) {
      return createEventFromTemplate(template, null);
    }
  }
  return null;
}

export const createEventFromTemplate = (
  template: EventTemplate,
  territory: Territory | null
): GameEvent => {
  return {
    id: `${template.id}_${Date.now()}`,
    title: template.title,
    description: template.description,
    type: template.type,
    populationChange: template.populationChange,
    targetTerritoryId: territory?.id || null,
    timestamp: Date.now(),
    category: template.category,
  };
};

export const getEventsByCategory = (category: string): EventTemplate[] => {
  const events: EventTemplate[] = [];

  for (const key of Object.keys(territoryEvents)) {
    const list = territoryEvents[key];
    events.push(...list.filter((e) => e.category === category));
  }

  if (milestoneEvents) {
    events.push(...milestoneEvents.filter((e) => e.category === category));
  }

  return events;
};
