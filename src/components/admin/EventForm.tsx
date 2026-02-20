import React from 'react';
import { useTranslation } from 'react-i18next';
import Input from '../common/Input';
import Label from '../common/Label';
import { EventTemplate } from './EventTable';

interface Props {
  editing: EventTemplate | null;
  form: Partial<EventTemplate>;
  handleChange: (
    e: React.ChangeEvent<HTMLInputElement | HTMLSelectElement | HTMLTextAreaElement>,
  ) => void;
  save: () => void;
  resetForm: () => void;
}

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
        <div className="flex flex-col gap-1.5">
          <Label>{t('admin.id')}</Label>
          <Input name="id" value={form.id || ''} onChange={handleChange} />
        </div>
        <div className="flex flex-col gap-1.5">
          <Label>{t('admin.titleCol')}</Label>
          <Input name="title" value={form.title || ''} onChange={handleChange} />
        </div>
        <div className="flex flex-col gap-1.5">
          <Label>{t('admin.description')}</Label>
          <textarea
            className="p-3 rounded-md bg-cinematic-surface border border-cinematic-border text-white text-sm outline-none focus:border-brand-primary focus:ring-1 focus:ring-brand-primary transition-all h-24"
            name="description"
            value={form.description || ''}
            onChange={handleChange}
          />
        </div>
        <div className="flex flex-col gap-1.5">
          <Label>{t('admin.type')}</Label>
          <select
            className="p-3 rounded-md bg-cinematic-surface border border-cinematic-border text-white text-sm outline-none focus:border-brand-primary focus:ring-1 focus:ring-brand-primary transition-all"
            name="type"
            value={form.type || 'immigration'}
            onChange={handleChange}
          >
            <option value="immigration">immigration</option>
            <option value="emigration">emigration</option>
            <option value="disaster">disaster</option>
            <option value="milestone">milestone</option>
          </select>
        </div>
        <div className="flex flex-col gap-1.5">
          <Label>{t('admin.territory')}</Label>
          <Input name="territoryType" value={form.territoryType || ''} onChange={handleChange} />
        </div>
        <div className="flex flex-col gap-1.5">
          <Label>{t('admin.population')}</Label>
          <Input
            name="populationChange"
            type="number"
            step="0.1"
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
            value={form.probability ?? 0}
            onChange={handleChange}
          />
        </div>
        <div className="flex flex-col gap-1.5">
          <Label>{t('admin.category')}</Label>
          <Input name="category" value={form.category || ''} onChange={handleChange} />
        </div>
        <div className="flex flex-col gap-1.5">
          <Label>{t('admin.threshold')}</Label>
          <Input
            name="threshold"
            type="number"
            value={form.threshold ?? 0}
            onChange={handleChange}
          />
        </div>
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
