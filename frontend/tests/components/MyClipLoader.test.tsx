import { render } from '@testing-library/react';
import MyClipLoader from '../../src/components/MyClipLoader';

jest.mock('react-spinners', () => ({
  ClipLoader: jest.fn(({ loading, _cssOverride }) => {
    if (loading) {
      return <div>loading</div>;
    }

    return null;
  }),
}));

describe('MyClipLoader', () => {
  test('<MyClipLoader> rendering test', () => {
    const { container } = render(<MyClipLoader />);
    expect(container.innerHTML).toBe('<div>loading</div>');
  });
});
