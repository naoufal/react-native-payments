import { requireNativeComponent } from 'react-native'
import GPayProxy from "./GooglePayProxy";

export const GooglePayImage = requireNativeComponent("GooglePayImageView");
export const GPayRequest = GPayProxy;