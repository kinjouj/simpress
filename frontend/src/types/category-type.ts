export type CategoryType = {
  key: string
  name: string
  count: number
  children?: Record<string, CategoryType>
};

export type CategoriesType = {
  [key: string]: CategoryType
};
