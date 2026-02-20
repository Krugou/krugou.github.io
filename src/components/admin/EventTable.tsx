import React from 'react';
import { useTranslation } from 'react-i18next';

export interface EventTemplate {
  id: string;
  title: string;
  description: string;
  type: string;
  territoryType: string;
  populationChange: number;
  probability: number;
  category: string;
  threshold?: number;
}

interface Props {
  events: EventTemplate[];
  startEdit: (evt: EventTemplate) => void;
  remove: (evt: EventTemplate) => void;
}

const EventTable: React.FC<Props> = ({ events, startEdit, remove }) => {
  const { t } = useTranslation();

  return (
    <div className="overflow-x-auto mb-8 bg-cinematic-card rounded-xl border border-cinematic-border p-4">
      <table className="w-full text-left border-collapse">
        <thead>
          <tr>
            <th>{t('admin.id')}</th>
            <th>{t('admin.titleCol')}</th>
            <th>{t('admin.type')}</th>
            <th>{t('admin.territory')}</th>
            <th>{t('admin.population')}</th>
            <th>{t('admin.probability')}</th>
            <th>{t('admin.category')}</th>
            <th>{t('admin.threshold')}</th>
            <th>{t('admin.actions')}</th>
          </tr>
        </thead>
        <tbody>
          {events.map((e) => (
            <tr
              key={e.id}
              className="border-t border-cinematic-border hover:bg-cinematic-surface transition-colors"
            >
              <td className="p-2">{e.id}</td>
              <td className="p-2">{e.title}</td>
              <td className="p-2">{e.type}</td>
              <td className="p-2">{e.territoryType}</td>
              <td className="p-2">{e.populationChange}</td>
              <td className="p-2">{e.probability}</td>
              <td className="p-2">{e.category}</td>
              <td className="p-2">{e.threshold ?? ''}</td>
              <td className="p-2 flex gap-2">
                <button className="text-brand-primary" onClick={() => startEdit(e)}>
                  {t('admin.editEvent')}
                </button>
                <button className="text-brand-danger" onClick={() => remove(e)}>
                  {t('admin.delete')}
                </button>
              </td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
};

export default EventTable;
