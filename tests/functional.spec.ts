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
    // Wait for translations to load - the button should not show the key "ui.signInUp"
    const signInButton = page.getByRole('button', { name: /Sign In \/ Sign Up/i });
    await expect(signInButton).toBeVisible({ timeout: 10000 });

    await signInButton.click();
    await expect(page.getByRole('dialog')).toBeVisible();

    // Use .first() when multiple close buttons exist
    await page.getByRole('button', { name: /Close/i }).first().click();
    await expect(page.getByRole('dialog')).not.toBeVisible();
  });
});
