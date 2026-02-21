'use client';

import React, { useEffect, useState } from 'react';
import { useTranslation } from 'react-i18next';
import Link from 'next/link';
import PolicySelector from '../../components/admin/PolicySelector';
import TechSelector from '../../components/admin/TechSelector';
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
  const { gameState, togglePolicy, toggleTech, simulateTicks } = useGame();
  const [events, setEvents] = useState<EventTemplate[]>([]);
  const [editing, setEditing] = useState<EventTemplate | null>(null);
  const [form, setForm] = useState<Partial<EventTemplate>>({});
  const [notification, setNotification] = useState('');
  const [isServerOffline, setIsServerOffline] = useState(false);

  const fetchEvents = React.useCallback(async () => {
    try {
      const res = await fetch('/api/admin/events');
      if (!res.ok) {
        setIsServerOffline(true);
        return;
      }
      const data = await res.json();
      setEvents(data);
      setIsServerOffline(false);
    } catch {
      setIsServerOffline(true);
    }
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
    try {
      await fetch(url, {
        method,
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(body),
      });
      await fetchEvents();
      resetForm();
    } catch {
      setIsServerOffline(true);
    }
  };

  const remove = async (event: EventTemplate) => {
    try {
      await fetch('/api/admin/events', {
        method: 'DELETE',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          eventId: event.id,
          territoryType: event.territoryType,
        }),
      });
      await fetchEvents();
    } catch {
      setIsServerOffline(true);
    }
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

      {isServerOffline && (
        <div className="mb-6 p-4 rounded-lg border border-red-500/40 bg-red-950/30 text-red-300 flex items-center gap-3">
          <span className="text-2xl">⚠️</span>
          <div>
            <p className="font-bold text-red-200">No local admin server online</p>
            <p className="text-sm mt-1 text-red-400">
              Start the backend with{' '}
              <code className="bg-red-900/40 px-1 rounded">npm run server</code> to manage events.
            </p>
          </div>
          <button
            className="ml-auto btn btn-secondary text-xs px-3 py-1"
            onClick={() => fetchEvents()}
          >
            Retry
          </button>
        </div>
      )}

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
      <TechSelector unlockedTechs={gameState.techs} toggleTech={toggleTech} />

      {isServerOffline ? (
        <div className="text-slate-500 italic mt-6">
          Event management is unavailable while the admin server is offline.
        </div>
      ) : (
        <>
          {Array.isArray(events) ? (
            <EventTable events={events} startEdit={startEdit} remove={remove} />
          ) : (
            <div className="text-orange-400">Failed to load events</div>
          )}
          <EventForm
            editing={editing}
            form={form}
            handleChange={handleChange}
            save={save}
            resetForm={resetForm}
          />
        </>
      )}
    </div>
  );
};
export default AdminPage;
