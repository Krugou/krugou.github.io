import { test, expect } from '@playwright/test';

test.describe('Functional Tests', () => {
  test.beforeEach(async ({ page }) => {
    await page.addInitScript(() => {
      localStorage.setItem('app_lang', 'en');
      localStorage.setItem('app_onboarded', '1');
    });
    await page.goto('/');
  });

  test('should toggle modal', async ({ page }) => {
    // dismiss storage choice if it appears on first load (may render async)
    try {
      await page.locator('button', { hasText: 'Local Deck' }).click({ timeout: 5000 });
    } catch {
      // if the prompt never shows, continue silently
    }

    // simply wait for primary button to exist, text may still be the key
    const signInButton = page.locator('header button.btn-primary').first();
    await expect(signInButton).toBeVisible({ timeout: 10000 });

    await signInButton.click();
    await expect(page.getByRole('dialog')).toBeVisible();

    // Use .first() when multiple close buttons exist
    await page.getByRole('button', { name: /close/i }).first().click();
    await expect(page.getByRole('dialog')).not.toBeVisible();
  });
});
