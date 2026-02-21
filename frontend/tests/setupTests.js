require('@testing-library/jest-dom');

jest.mock('react-loading-skeleton/dist/skeleton.css', () => {});
jest.mock('prismjs/themes/prism-tomorrow.css', () => ({}));
jest.mock('prismjs/plugins/line-numbers/prism-line-numbers.css', () => ({}));
