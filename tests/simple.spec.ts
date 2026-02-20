import { test, expect } from '@playwright/test';

test('sanity check', async ({ page }) => {
  await page.goto('/');
  await expect(page).toHaveTitle(/The Immigrants - Space Colonization/i);
});
