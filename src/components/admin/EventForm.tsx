import React from 'react';
import { useTranslation } from 'react-i18next';
import Input from '../common/Input';
import Label from '../common/Label';
import { EventTemplate } from './EventTable';

const TERRITORY_TYPES = [
  'rural',
  'suburbs',
  'urban',
  'metropolis',
  'border',
  'coastal',
  'caves',
  'underground',
  'mountains',
  'desert',
  'arctic',
  'moon',
  'orbital',
  'spaceStation',
  'interstellar',
  'milestone',
] as const;

const EVENT_TYPES = ['immigration', 'emigration', 'disaster', 'opportunity', 'milestone'] as const;
const CATEGORIES = ['opportunity', 'disaster', 'milestone', 'neutral'] as const;

interface Props {
  editing: EventTemplate | null;
  form: Partial<EventTemplate>;
  handleChange: (
    e: React.ChangeEvent<HTMLInputElement | HTMLSelectElement | HTMLTextAreaElement>,
  ) => void;
  save: () => void;
  resetForm: () => void;
}

const selectClass =
  'p-3 rounded-md bg-cinematic-surface border border-cinematic-border text-white text-sm outline-none focus:border-brand-primary focus:ring-1 focus:ring-brand-primary transition-all';

const EventForm: React.FC<Props> = ({ editing, form, handleChange, save, resetForm }) => {
  const { t } = useTranslation();

  return (
    <div className="cinematic-card max-w-2xl">
      <h2 className="text-2xl font-bold mb-4">
        {editing ? t('admin.editEvent') : t('admin.newEvent')}
      </h2>
      <form
        className="flex flex-col gap-4"
        onSubmit={(e) => {
          e.preventDefault();
          save();
        }}
      >
        {/* ── Row 1: ID + Title ── */}
        <div className="grid grid-cols-2 gap-4">
          <div className="flex flex-col gap-1.5">
            <Label>{t('admin.id')}</Label>
            <Input name="id" value={form.id || ''} onChange={handleChange} />
          </div>
          <div className="flex flex-col gap-1.5">
            <Label>{t('admin.titleCol')}</Label>
            <Input name="title" value={form.title || ''} onChange={handleChange} />
          </div>
        </div>

        {/* ── Description ── */}
        <div className="flex flex-col gap-1.5">
          <Label>{t('admin.description')}</Label>
          <textarea
            className={`${selectClass} h-24`}
            name="description"
            value={form.description || ''}
            onChange={handleChange}
          />
        </div>

        {/* ── Row 2: Type + Category ── */}
        <div className="grid grid-cols-2 gap-4">
          <div className="flex flex-col gap-1.5">
            <Label>{t('admin.type')}</Label>
            <select
              className={selectClass}
              name="type"
              value={form.type || 'immigration'}
              onChange={handleChange}
            >
              {EVENT_TYPES.map((v) => (
                <option key={v} value={v}>
                  {v}
                </option>
              ))}
            </select>
          </div>
          <div className="flex flex-col gap-1.5">
            <Label>{t('admin.category')}</Label>
            <select
              className={selectClass}
              name="category"
              value={form.category || 'opportunity'}
              onChange={handleChange}
            >
              {CATEGORIES.map((v) => (
                <option key={v} value={v}>
                  {v}
                </option>
              ))}
            </select>
          </div>
        </div>

        {/* ── Row 3: Territory + Threshold ── */}
        <div className="grid grid-cols-2 gap-4">
          <div className="flex flex-col gap-1.5">
            <Label>{t('admin.territory')}</Label>
            <select
              className={selectClass}
              name="territoryType"
              value={form.territoryType || 'rural'}
              onChange={handleChange}
            >
              {TERRITORY_TYPES.map((v) => (
                <option key={v} value={v}>
                  {v}
                </option>
              ))}
            </select>
          </div>
          <div className="flex flex-col gap-1.5">
            <Label>{t('admin.threshold')}</Label>
            <Input
              name="threshold"
              type="number"
              value={form.threshold ?? 0}
              onChange={handleChange}
              placeholder="Milestone threshold (0 = none)"
            />
          </div>
        </div>

        {/* ── Row 4: Pop Change + Probability ── */}
        <div className="grid grid-cols-2 gap-4">
          <div className="flex flex-col gap-1.5">
            <Label>{t('admin.population')}</Label>
            <Input
              name="populationChange"
              type="number"
              step="1"
              value={form.populationChange ?? 0}
              onChange={handleChange}
            />
          </div>
          <div className="flex flex-col gap-1.5">
            <Label>{t('admin.probability')}</Label>
            <Input
              name="probability"
              type="number"
              step="0.01"
              min="0"
              max="1"
              value={form.probability ?? 0.5}
              onChange={handleChange}
            />
          </div>
        </div>

        {/* ── Metadata (read-only when editing) ── */}
        {editing && (form as Record<string, unknown>).createdBy && (
          <div className="text-xs text-slate-500 border-t border-cinematic-border pt-3 mt-2 flex flex-wrap gap-x-6 gap-y-1">
            <span>
              Created by: <strong>{(form as Record<string, unknown>).createdBy as string}</strong>
            </span>
            {(form as Record<string, unknown>).createdAt && (
              <span>
                Created:{' '}
                {new Date((form as Record<string, unknown>).createdAt as number).toLocaleString()}
              </span>
            )}
            {(form as Record<string, unknown>).updatedAt && (
              <span>
                Updated:{' '}
                {new Date((form as Record<string, unknown>).updatedAt as number).toLocaleString()}
              </span>
            )}
            {(form as Record<string, unknown>).source && (
              <span>Source: {(form as Record<string, unknown>).source as string}</span>
            )}
          </div>
        )}

        <div className="flex gap-4 mt-4">
          <button className="btn btn-primary w-full" type="submit">
            {t('admin.save')}
          </button>
          <button className="btn btn-secondary w-full" type="button" onClick={resetForm}>
            {t('admin.cancel')}
          </button>
        </div>
      </form>
    </div>
  );
};

export default EventForm;
