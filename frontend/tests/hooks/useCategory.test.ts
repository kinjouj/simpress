import * as Router from 'react-router-dom';
import { useCategory } from '../../src/hooks/useCategory';

jest.mock('react-router-dom', (): typeof Router => ({
  ...jest.requireActual('react-router-dom'),
  useParams: jest.fn(),
}));

const mockedUseParams = Router.useParams as jest.Mock;

describe('useCategor', () => {
  afterEach(() => {
    mockedUseParams.mockReset();
  });

  test('useCategory test', () => {
    mockedUseParams.mockReturnValue({ category: 'test' });
    expect(useCategory()).toBe('test');
  });

  test('categoryパラメーターが不正な場合', () => {
    mockedUseParams.mockReturnValue({});
    expect(useCategory()).toBeNull();
  });
});
