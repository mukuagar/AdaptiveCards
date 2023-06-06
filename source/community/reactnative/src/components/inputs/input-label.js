import React from "react";
import {
	StyleSheet,
	Text,
	View
} from 'react-native';
import { Label } from '../elements';
import { Registry } from '../registration/registry';
import * as Constants from '../../utils/constants';
import { isNullOrEmpty } from '../../utils/util';
import { TextColor, ContainerStyle } from '../../utils/enums';

export default class InputLabel extends React.Component {

	constructor(props) {
		super(props);
		this.label = props.label || Constants.EmptyString;
		this.wrap = props.wrap || false;
		this.style = props.style || {};
		this.isRequired = props.isRequired || false;
		this.hostConfig = props.configManager.hostConfig;
	}

	render() {
		const { label, wrap, style } = this;
		let inputLabel = null;
		if (label != Constants.EmptyString) {
			if (typeof label == Constants.TypeString) {
				inputLabel = (
					<Label
						text={label}
						style={[this.props.configManager.styleConfig.defaultFontConfig, style]}
						configManager={this.props.configManager}
						wrap={wrap} />
				);
			} else if (typeof label == Constants.TypeObject && this.isValidLabelType(label.type)) {
				let element = [];
				if (!isNullOrEmpty(label)) {
					element = Registry.getManager().parseRegistryComponents([label], this.context.onParseError);
				}
				if (element.length > 0) inputLabel = React.cloneElement(element[0], { configManager: this.props.configManager });
			}
		}
		if (inputLabel) {
			return (
				<View style={styles.container}>
					<View>{inputLabel}</View>
					{this.isRequired && this.getRedAsterisk()}
				</View>
			);
		} else return inputLabel;
	}

	isValidLabelType = type => {
		return !isNullOrEmpty(type) && (type == Constants.TypeTextBlock || type == Constants.TypeRichTextBlock);
	}

	getRedAsterisk = () => {
		const colorDefinition = this.hostConfig.getTextColorForStyle(TextColor.Attention, ContainerStyle.Default);
		return (<Text style={[styles.redAsterisk, { color: colorDefinition.default }]}>*</Text>);
	}
}

const styles = StyleSheet.create({
	container: {
		flexDirection: Constants.FlexRow,
		marginLeft: 5
	},
	redAsterisk: {
		marginLeft: 2,
		alignSelf: Constants.CenterString
	}
});