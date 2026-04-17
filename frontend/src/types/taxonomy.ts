export type TaxonomyType = {
  key: string
  name: string
  count: number
  children?: TaxonomyType[]
};
