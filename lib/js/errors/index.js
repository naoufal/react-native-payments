import ExtendableError from 'es6-error';

const ERROR_MESSAGES = {
  AbortError: 'The operation was aborted.', // Request cancelled
  InvalidStateError: 'The object is in an invalid state.',
  NotAllowedError:
    'The request is not allowed by the user agent or the platform in the current context, possibly because the user denied permission.',
  NotSupportedError: 'The operation is not supported.',
  SecurityError: 'The operation is insecure.'
};

class ReactNativePaymentsError extends ExtendableError {
  constructor(errorMessage) {
    super(`[ReactNativePayments] ${errorMessage}`);
  }
}

export class DOMException extends ReactNativePaymentsError {
  constructor(errorType) {
    const errorMessage = ERROR_MESSAGES[errorType] || errorType;

    super(`DOMException: ${errorMessage}`);
  }
}

export class TypeError extends ReactNativePaymentsError {
  constructor(errorMessage) {
    super(`TypeError: ${errorMessage}`);
  }
}

export class ConstructorError extends ReactNativePaymentsError {
  constructor(errorMessage) {
    super(`Failed to construct 'PaymentRequest':  ${errorMessage}`);
  }
}

export class GatewayError extends ExtendableError {
  constructor(errorMessage) {
    super(`${errorMessage}`);
  }
}
