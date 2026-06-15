/**
 * Safari-compatibility shims for APIs that are unavailable or behave differently
 * in Apple's WebKit extension environment.
 */

/**
 * Detects whether the current host browser is Safari.
 * Relies on UA string; safe to use in service workers and content scripts.
 */
export function isSafariBrowser(): boolean {
  if (typeof navigator === "undefined") return false
  const ua = navigator.userAgent
  return /safari/i.test(ua) && !/chrome|chromium|crios|fxios/i.test(ua)
}

/**
 * Safely calls chrome.runtime.setUninstallURL, which is not available in Safari.
 * Silently no-ops instead of throwing.
 */
export function safeSetUninstallURL(url: string): void {
  try {
    if (typeof chrome?.runtime?.setUninstallURL === "function") {
      chrome.runtime.setUninstallURL(url)
    }
  } catch {
    // safari: setUninstallURL is not part of the Safari Extensions API
  }
}
