enum IsToDelivery {
  preparing(1),
  ready(2),
  delivered(3);

  final int value;
  const IsToDelivery(this.value);
}
