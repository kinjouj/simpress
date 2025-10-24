import * as Router from 'react-router-dom';
import { usePermalink } from '../../src/hooks/usePermalink';

jest.mock('react-router-dom', (): typeof Router => ({
  ...jest.requireActual('react-router-dom'),
  useParams: jest.fn(),
}));

const mockedUseParams = Router.useParams as jest.Mock;

describe('usePermalink', () => {
  afterEach(() => {
    mockedUseParams.mockReset();
  });

  test('usePermalink', () => {
    mockedUseParams.mockReturnValue({ '*': '2000/01/test.html' });
    expect(usePermalink()).toBe('2000/01/test.html');
  });

  test('permalinkパラメーターが不正な場合', () => {
    mockedUseParams.mockReturnValue({});
    expect(usePermalink()).toBeNull();
  });
});
