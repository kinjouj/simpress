export type PageInfoType = {
  page: number
};

export type PostType = {
  id: string
  title: string
  permalink: string
  cover: string
  content: string
  categories: CategoryType[]
};

export type CategoryType = {
  key: string
  name: string
};
