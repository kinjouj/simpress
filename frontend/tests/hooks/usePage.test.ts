import * as Router from 'react-router-dom';
import { usePage } from '../../src/hooks/usePage';

jest.mock('react-router-dom', (): typeof Router => ({
  ...jest.requireActual('react-router-dom'),
  useParams: jest.fn(),
}));

const mockedUseParams = Router.useParams as jest.Mock;

describe('usePage', () => {
  test('usePage test', () => {
    mockedUseParams.mockReturnValue({ page: 10 });
    const page = usePage();
    expect(page).toBe(10);
  });

  test('if useParams return null', () => {
    mockedUseParams.mockReturnValue({});
    expect(usePage()).toBe(1);
  });
});
