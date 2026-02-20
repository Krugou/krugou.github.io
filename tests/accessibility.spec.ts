import { test, expect } from '@playwright/test';
import AxeBuilder from '@axe-core/playwright';
import fs from 'fs';
import path from 'path';
/* eslint-disable no-console -- logging violations useful in tests */

test.describe('Accessibility', () => {
  test.beforeEach(async ({ page }) => {
    // mark onboarding complete and choose local storage so modal never appears
    await page.addInitScript(() => {
      localStorage.setItem('app_lang', 'en');
      localStorage.setItem('app_onboarded', '1');
      localStorage.setItem('useCloudChoice', 'false');
    });
  });

  test('should not have any automatically detectable accessibility issues', async ({ page }) => {
    try {
      await page.goto('/');
    } catch {}
    await page.waitForLoadState('networkidle').catch(() => console.log('Network idle timeout'));

    const results = await new AxeBuilder({ page })
      .withTags(['wcag2a', 'wcag2aa', 'wcag21a', 'wcag21aa'])
      .analyze();

    if (results.violations.length > 0) {
      fs.writeFileSync(
        path.resolve(process.cwd(), 'violations.json'),
        JSON.stringify(results.violations, null, 2),
      );
    }
    expect(results.violations).toEqual([]);
  });

  test('can toggle high contrast mode', async ({ page }) => {
    try {
      await page.goto('/');
    } catch {}
    // close any modal that might be blocking interactions
    await page.keyboard.press('Escape');
    // toggle via button
    await page.click('button[data-testid="contrast-toggle"]');
    const hasClass = await page.evaluate(() =>
      document.documentElement.classList.contains('high-contrast'),
    );
    expect(hasClass).toBe(true);
    // toggle back using keyboard shortcut
    await page.keyboard.press('Control+H');
    const noClass = await page.evaluate(() =>
      document.documentElement.classList.contains('high-contrast'),
    );
    expect(noClass).toBe(false);
  });
});
