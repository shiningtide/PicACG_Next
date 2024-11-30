export class NavItem {
  /**
   * 选中图片
   */
  selectedImg: Resource
  /**
   * 未选样式
   */
  unselectedImg: Resource
  /**
   * 标题
   */
  title: string
  /**
   * Index
   */
  index: number

  constructor(index: number, unselected: Resource, selectedImg: Resource, title = '') {
    this.selectedImg = selectedImg
    this.unselectedImg = unselected
    this.title = title
    this.index = index
  }
}