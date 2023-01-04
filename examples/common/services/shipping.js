function createShippingOption(id, label, price, selected = false) {
  return {
    id,
    label,
    amount: {
      currency: 'USD',
      value: price
    },
    selected
  };
}

function getRandomPrice(min = 0, max = 99) {
  const multiplier = 100;
  const minVal = min * multiplier;
  const maxVal = max * multiplier;
  const priceFloat =
    (Math.floor(Math.random() * (maxVal - minVal)) + minVal) / multiplier;

  return priceFloat.toString();
}

export function getShippingOptions() {
  return [
    createShippingOption('economy', 'Economy Shipping (5-7 Days)', '0.00'),
    createShippingOption(
      'express',
      'Express Shipping (2-3 Days)',
      getRandomPrice(5, 10)
    ),
    createShippingOption(
      'next-day',
      'Next Day Delivery',
      getRandomPrice(11, 20)
    )
  ];
}
