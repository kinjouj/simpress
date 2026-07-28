import '@testing-library/jest-dom/vitest';
//import { vi } from 'vitest';

vi.mock('react-loading-skeleton/dist/skeleton.css', () => ({}));
vi.mock('prismjs/themes/prism-tomorrow.css', () => ({}));
vi.mock('prismjs/plugins/line-numbers/prism-line-numbers.css', () => ({}));
