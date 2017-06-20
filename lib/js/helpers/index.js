import {
    isDecimal,
    isFloat,
    isInt,
    toFloat,
    toInt
} from 'validator';

export function isValidDecimalMonetaryValue(amountValue: string | number): bool {
    const isNumber = typeof amountValue === 'number';
    const isString = typeof amountValue === 'string';

    if (!isNumber && !isString) {
        return false;
    }

    return isNumber || isValidStringAmount(amountValue);
}

export function isValidStringAmount(stringAmount): bool {
    return isDecimal(stringAmount);
}

export function toNumber(string: string): number {
    if (isFloat(string)) {
        return toFloat(string);
    }

    if (isInt(string)) {
        return toInt(string);
    }
}