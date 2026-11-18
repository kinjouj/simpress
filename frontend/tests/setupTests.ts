import '@testing-library/jest-dom/vitest';

beforeEach(() => vi.spyOn(window, 'scrollTo').mockImplementation(() => {}));
