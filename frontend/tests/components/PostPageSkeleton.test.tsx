import { render } from '@testing-library/react';
import PostPageSkeleton from '../../src/components/PostPageSkeleton';

describe('PostPageSkeleton', () => {
  test('<PostPageSkeleton> test', () => {
    const { container } = render(<PostPageSkeleton />);
    expect(container.innerHTML).not.toBeNull();
    expect(container.querySelector('.post-content')).not.toBeNull();
  });
});
