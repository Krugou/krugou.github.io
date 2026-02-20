import React from 'react';
import { useTranslation } from 'react-i18next';

const TechTree: React.FC = () => {
  const { t } = useTranslation();
  return (
    <div className="p-8">
      <h1 className="text-3xl font-bold mb-4">{t('ui.techTree')}</h1>
      <p>{t('ui.techTreePlaceholder')}</p>
      <div className="mt-8 border border-cinematic-border rounded-lg p-6 bg-cinematic-surface text-center text-sm">
        {t('ui.techTreeComingSoon')}
      </div>
    </div>
  );
};

export default TechTree;
