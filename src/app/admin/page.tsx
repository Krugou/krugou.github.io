'use client';

import React, { useEffect, useState } from 'react';
import { useTranslation } from 'react-i18next';
import Link from 'next/link';
import PolicySelector from '../../components/admin/PolicySelector';
import EventTable from '../../components/admin/EventTable';
import EventForm from '../../components/admin/EventForm';

interface EventTemplate {
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

import { useGame } from '../../context/GameContext';

const AdminPage = () => {
  const { t } = useTranslation();
  const { gameState, togglePolicy, simulateTicks } = useGame();
  const [events, setEvents] = useState<EventTemplate[]>([]);
  const [editing, setEditing] = useState<EventTemplate | null>(null);
  const [form, setForm] = useState<Partial<EventTemplate>>({});
  const [notification, setNotification] = useState('');

  const fetchEvents = React.useCallback(async () => {
    const res = await fetch('/api/admin/events');
    const data = await res.json();
    setEvents(data);
  }, []);

  useEffect(() => {
    // eslint-disable-next-line react-hooks/set-state-in-effect
    fetchEvents();
  }, [fetchEvents]);

  const handleChange = (
    e: React.ChangeEvent<HTMLInputElement | HTMLSelectElement | HTMLTextAreaElement>,
  ) => {
    const { name, value } = e.target;
    setForm((f) => ({ ...f, [name]: value }));
  };

  const startEdit = (event: EventTemplate) => {
    setEditing(event);
    setForm({ ...event });
  };

  const resetForm = () => {
    setEditing(null);
    setForm({});
  };

  const save = async () => {
    const url = '/api/admin/events';
    const method = editing ? 'PUT' : 'POST';
    const body = {
      event: form,
      territoryType: form.territoryType || '',
    };
    await fetch(url, {
      method,
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(body),
    });
    await fetchEvents();
    resetForm();
  };

  const remove = async (event: EventTemplate) => {
    await fetch('/api/admin/events', {
      method: 'DELETE',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        eventId: event.id,
        territoryType: event.territoryType,
      }),
    });
    await fetchEvents();
  };

  return (
    <div className="container mx-auto px-4 lg:px-8 py-8 animate-fade-in max-w-7xl">
      <h1 className="text-3xl font-extrabold mb-6 flex justify-between items-center">
        <span>{t('admin.title')}</span>
        <Link href="/" className="text-sm text-brand-primary underline">
          {t('admin.back')}
        </Link>
      </h1>
      {notification && <div className="mb-4 text-green-400 font-semibold">{notification}</div>}

      {/* developer helper: simulate one hour (720 ticks) for testing */}
      <div className="mb-4">
        <button
          className="btn btn-secondary text-sm"
          onClick={() => {
            simulateTicks(720);
            setNotification(t('admin.simulated', { hours: 1 }));
            setTimeout(() => setNotification(''), 3000);
          }}
        >
          {t('admin.simulateHour')}
        </button>
      </div>
      <PolicySelector activePolicies={gameState.policies} togglePolicy={togglePolicy} />
      <EventTable events={events} startEdit={startEdit} remove={remove} />
      <EventForm
        editing={editing}
        form={form}
        handleChange={handleChange}
        save={save}
        resetForm={resetForm}
      />
    </div>
  );
};
export default AdminPage;
