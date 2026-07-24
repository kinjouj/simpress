export const testPostData = {
  id: '1',
  title: 'test1',
  date: Date.now().toString(),
  permalink: '/test.html',
  cover: '/images/no_image.png',
  taxonomies: { categories: [{ key: 'test', count: 1, name: 'Test' }] },
  content: 'test1',
  description: 'test1',
  prev: null,
  next: null,
  toc: [
    { id: 'section-1', text: 'toc-1', children: [] },
    { id: 'section-2', text: 'toc-2', children: [] },
  ],
  similarities: [
    { id: '2', title: 'test2', permalink: '/test2.html' },
    { id: '3', title: 'test3', permalink: '/test3.html' },
  ],
};
