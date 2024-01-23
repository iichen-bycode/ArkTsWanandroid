export class ComponentRef <T> {
  value: T

  export(ref: T) {
    this.value = ref
  }

  static useRef<T>() {
    return new ComponentRef<T>()
  }
}