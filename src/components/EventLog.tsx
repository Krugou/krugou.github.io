import React from 'react';
import { GameEvent, EventType } from '../models/types';
import { TrendingUp, TrendingDown, Star, Activity } from 'lucide-react';
import { useTranslation } from 'react-i18next';
import Text from './common/Text';

interface Props {
  events: GameEvent[];
}

const getEventStyles = (type: EventType) => {
  switch (type) {
    case EventType.opportunity:
    case EventType.immigration:
      return {
        icon: <TrendingUp size={16} className="text-brand-success" />,
        borderColor: 'border-brand-success',
        bgColor: 'bg-brand-success/10',
        textColor: 'text-brand-success',
      };
    case EventType.disaster:
    case EventType.emigration:
      return {
        icon: <TrendingDown size={16} className="text-brand-danger" />,
        borderColor: 'border-brand-danger',
        bgColor: 'bg-brand-danger/10',
        textColor: 'text-brand-danger',
      };
    case EventType.milestone:
      return {
        icon: (
          <Star
            size={16}
            className="text-brand-warning drop-shadow-[0_0_8px_rgba(210,153,34,0.5)]"
            fill="currentColor"
          />
        ),
        borderColor: 'border-brand-warning',
        bgColor: 'bg-brand-warning/15',
        textColor: 'text-brand-warning',
      };
    default:
      return {
        icon: <Activity size={16} className="text-slate-400" />,
        borderColor: 'border-cinematic-border',
        bgColor: 'bg-cinematic-surface',
        textColor: 'text-slate-300',
      };
  }
};

const EventLog = ({ events }: Props) => {
  const { t } = useTranslation();
  if (events.length === 0) {
    return (
      <div className="cinematic-card h-full min-h-[400px] flex items-center justify-center border-dashed border-cinematic-border">
        <Text as="p" variant="muted" className="text-sm italic">
          {t('ui.awaiting')}
        </Text>
      </div>
    );
  }

  return (
    <div className="cinematic-card h-full max-h-[600px] overflow-y-auto flex flex-col gap-3 scroll-smooth">
      {events.map((e) => {
        const style = getEventStyles(e.type);
        const timeStr = new Date(e.timestamp).toLocaleTimeString();

        return (
          <div
            key={e.id}
            className={`animate-fade-in p-3 rounded-md border-l-4 ${style.bgColor} ${style.borderColor} transition-all hover:brightness-110`}
          >
            <div className="flex justify-between items-center mb-1">
              <div className="flex items-center gap-2">
                {style.icon}
                <Text as="span" variant="base" className="text-sm font-bold tracking-wide">
                  {e.title}
                </Text>
              </div>
              <Text as="span" variant="muted" className="text-xs font-mono">
                {timeStr}
              </Text>
            </div>

            <Text as="p" className="text-xs text-slate-300 my-2 leading-relaxed">
              {e.description}
            </Text>

            {e.populationChange !== 0 && (
              <div className={`text-xs font-bold ${style.textColor}`}>
                {e.populationChange > 0 ? '+' : ''}
                {Math.floor(e.populationChange).toLocaleString()} {t('ui.population')}
              </div>
            )}
          </div>
        );
      })}
    </div>
  );
};

export default EventLog;
