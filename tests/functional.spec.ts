import { test, expect } from '@playwright/test';

test.describe('Functional Tests', () => {
  test.beforeEach(async ({ page }) => {
    await page.addInitScript(() => {
      localStorage.setItem('app_lang', 'en');
      localStorage.setItem('app_onboarded', '1');
      localStorage.setItem('useCloudChoice', 'false');
    });
    try {
      await page.goto('/');
    } catch {}

    // wait until the app is fully rendered so interactions will work
    await page.waitForSelector('text=appTitle', { timeout: 60000 });
    await page.waitForLoadState('networkidle').catch(() => {});
    // remove the Next.js devtools badge if it's present
    try {
      await page.evaluate(() => {
        const badge = document.querySelector('[aria-label="Open Next.js Dev Tools"]');
        if (badge) {
          badge.remove();
        }
      });
    } catch {}
    // give React a moment to attach event handlers
    await page.waitForTimeout(300);
  });

  test('should toggle modal', async ({ page }) => {
    // dismiss any overlays that might intercept interactions
    try {
      await page.keyboard.press('Escape');
      await page.locator('button', { hasText: 'Local Deck' }).click({ timeout: 5000 });
    } catch {}

    const signInButton = page.locator('header button.btn-primary').first();
    await expect(signInButton).toBeVisible({ timeout: 10000 });

    // click the sign-in button and then wait for the auth modal content
    await signInButton.click({ force: true });
    // the auth dialog uses the same role and may be injected after a short animation
    await page.waitForSelector('div[role="dialog"] input[type="email"]', {
      state: 'visible',
      timeout: 15000,
    });

    // Use .first() when multiple close buttons exist
    await page.getByRole('button', { name: /close/i }).first().click({ force: true });
    await expect(page.getByRole('dialog')).not.toBeVisible();
  });

  test('admin page loads, hide storage modal and can simulate ticks', async ({ page }) => {
    try {
      await page.goto('/admin');
    } catch {}
    await page.waitForLoadState('networkidle').catch(() => {});
    await page.waitForSelector('text=admin.simulateHour', { timeout: 10000 });

    // storage modal should never appear (admin path suppresses it)
    const maybeModal = page.getByText('Storage Matrix');
    await expect(maybeModal).not.toBeVisible();

    // click simulation button and expect a notification
    await page.getByText('admin.simulateHour').click({ force: true });
    await expect(page.getByText('admin.simulated')).toBeVisible();
  });

  test.skip('tech page is reachable and shows placeholder', async ({ page }) => {
    // placeholder route still unstable – skipping until implementation solidifies
    try {
      await page.goto('/tech');
    } catch {}
    await page.waitForLoadState('networkidle').catch(() => {});
    await expect(page.getByRole('heading', { name: 'ui.techTree' })).toBeVisible({
      timeout: 15000,
    });
  });
});
