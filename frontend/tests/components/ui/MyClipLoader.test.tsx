import { render } from '@testing-library/react';
import MyClipLoader from '../../../src/components/ui/MyClipLoader';

jest.mock('react-spinners', () => ({
  ClipLoader: jest.fn(({ loading }) => {
    if (loading) {
      return <div>loading</div>;
    }

    return null;
  }),
}));

describe('MyClipLoader', () => {
  test('<MyClipLoader> test', () => {
    const { container } = render(<MyClipLoader />);
    expect(container.innerHTML).toBe('<div>loading</div>');
  });
});
