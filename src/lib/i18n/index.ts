import { browser } from '$app/environment';
import { init, register } from 'svelte-i18n';

const defaultLocale = 'en';
export const initialLocale = browser ? window.navigator.language : defaultLocale;

register('en', () => import('./locales/en.json'));
register('de', () => import('./locales/de.json'));

init({
  fallbackLocale: defaultLocale,
  initialLocale: initialLocale
});
