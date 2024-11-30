export class NavItem {
  /**
   * 选中图片
   */
  selectImg: Resource
  /**
   * 未选样式
   */
  unselected: Resource
  /**
   * 是否选择
   */
  isSelect: boolean = false
  /**
   * 标题
   */
  title: string
  /**
   * Index
   */
  index: number

  constructor(index = 0, unselected: Resource, selectImg: Resource, title = '') {
    this.selectImg = selectImg
    this.unselected = unselected
    this.title = title
    this.index = index
  }
}