'use client';

import React, { useEffect, useState } from 'react';
import Input from '../../components/common/Input';
import Label from '../../components/common/Label';

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

const AdminPage = () => {
  const [events, setEvents] = useState<EventTemplate[]>([]);
  const [editing, setEditing] = useState<EventTemplate | null>(null);
  const [form, setForm] = useState<Partial<EventTemplate>>({});

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
    e: React.ChangeEvent<
      HTMLInputElement | HTMLSelectElement | HTMLTextAreaElement
    >,
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
      <h1 className="text-3xl font-extrabold mb-6">Admin - Event Manager</h1>
      <div className="overflow-x-auto mb-8 bg-cinematic-card rounded-xl border border-cinematic-border p-4">
        <table className="w-full text-left border-collapse">
          <thead>
            <tr>
              <th>ID</th>
              <th>Title</th>
              <th>Type</th>
              <th>Territory</th>
              <th>Population</th>
              <th>Probability</th>
              <th>Category</th>
              <th>Threshold</th>
              <th>Actions</th>
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
                  <button
                    className="text-brand-primary"
                    onClick={() => startEdit(e)}
                  >
                    Edit
                  </button>
                  <button
                    className="text-brand-danger"
                    onClick={() => remove(e)}
                  >
                    Delete
                  </button>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>

      <div className="cinematic-card max-w-2xl">
        <h2 className="text-2xl font-bold mb-4">
          {editing ? 'Edit event' : 'New event'}
        </h2>
        <form
          className="flex flex-col gap-4"
          onSubmit={(e) => {
            e.preventDefault();
            save();
          }}
        >
          <div className="flex flex-col gap-1.5">
            <Label>ID</Label>
            <Input
              name="id"
              value={form.id || ''}
              onChange={handleChange}
            />
          </div>
          <div className="flex flex-col gap-1.5">
            <Label>Title</Label>
            <Input
              name="title"
              value={form.title || ''}
              onChange={handleChange}
            />
          </div>
          <div className="flex flex-col gap-1.5">
            <Label>Description</Label>
            <textarea
              className="p-3 rounded-md bg-cinematic-surface border border-cinematic-border text-white text-sm outline-none focus:border-brand-primary focus:ring-1 focus:ring-brand-primary transition-all h-24"
              name="description"
              value={form.description || ''}
              onChange={handleChange}
            />
          </div>
          <div className="flex flex-col gap-1.5">
            <Label>Type</Label>
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
            <Label>Territory</Label>
            <Input
              name="territoryType"
              value={form.territoryType || ''}
              onChange={handleChange}
            />
          </div>
          <div className="flex flex-col gap-1.5">
            <Label>Population Change</Label>
            <Input
              name="populationChange"
              type="number"
              step="0.1"
              value={form.populationChange ?? 0}
              onChange={handleChange}
            />
          </div>
          <div className="flex flex-col gap-1.5">
            <Label>Probability</Label>
            <Input
              name="probability"
              type="number"
              step="0.01"
              value={form.probability ?? 0}
              onChange={handleChange}
            />
          </div>
          <div className="flex flex-col gap-1.5">
            <Label>Category</Label>
            <Input
              name="category"
              value={form.category || ''}
              onChange={handleChange}
            />
          </div>
          <div className="flex flex-col gap-1.5">
            <Label>Threshold</Label>
            <Input
              name="threshold"
              type="number"
              value={form.threshold ?? 0}
              onChange={handleChange}
            />
          </div>
          <div className="flex gap-4 mt-4">
            <button className="btn btn-primary w-full" type="submit">
              Save
            </button>
            <button
              className="btn btn-secondary w-full"
              type="button"
              onClick={resetForm}
            >
              Cancel
            </button>
          </div>
        </form>
      </div>
    </div>
  );
};

export default AdminPage;
