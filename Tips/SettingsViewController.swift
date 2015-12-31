//
//  SettingsViewController.swift
//  Tips
//
//  Created by Eric Zim on 12/2/15.
//  Copyright © 2015 Eric Zim. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
	
	@IBOutlet weak var defaultTipControl: UISegmentedControl!
	
	@IBOutlet weak var localePicker: UIPickerView!
	
	var localeData: [String] = [String]()
	
	let defaults = NSUserDefaults.standardUserDefaults()
	
	let currency = NSNumberFormatter()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Do any additional setup after loading the view.
		
		// Connect data to picker
		self.localePicker.delegate = self
		self.localePicker.dataSource = self
		
		localeData = [ "Afghanistan", "Albania", "Algeria", "Argentina", "Armenia", "Australia", "Austria", "Bahrain", "Bangladesh", "Belarus", "Belgium", "Bolivia", "Botswana", "Brazil", "Cambodia", "Canada", "Chile", "China", "Colombia", "Costa Rica", "Cuba", "Cyprus", "Czech Republic", "Denmark", "Djibouti", "Dominican Republic", "Ecuador", "Egypt", "El Salvador", "Estonia", "Ethiopia", "Finland", "France", "Georgia", "Germany", "Ghana", "Greece", "Guatemala", "Honduras", "Hong Kong", "Hungary", "Iceland", "India", "Indonesia", "Iran", "Iraq", "Ireland", "Israel", "Italy", "Japan", "Jordan", "Kenya", "Kuwait", "Laos", "Latvia", "Lebanon", "Libya", "Lithuania", "Luxembourg", "Macedonia", "Malta", "Mexico", "Mongolia", "Montenegro", "Morocco", "Nepal", "Netherlands", "New Zealand", "Nicaragua", "Nigeria", "Norway", "Oman", "Pakistan", "Panama", "Paraguay", "Peru", "Philippines", "Polish", "Portugal", "Qatar", "Romania", "Russian Federation", "Rwanda", "Saudi Arabia", "Senegal", "Serbia", "Singapore", "Slovakia", "Slovenia", "Somalia", "South Africa", "South Korea", "Spain", "Sri Lanka", "Sudan", "Sweden", "Switzerland", "Syria", "Taiwan", "Tajikistan", "Thailand", "Tunisia", "Turkey", "UAE", "Ukraine", "United Kingdom", "United States", "Uruguay", "Uzbekistan", "Venezuela", "Vietnam", "Yemen" ]
		
		
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	// **********************************
	// UIPicker required overload methods
	
	// set the number of columns
	func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
		return 1
	}
	
	// return custom array size for picker data
	func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return localeData.count
	}
	
	// return custom array elements for picker
	func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return localeData[row]
	}
	
	// determine which selection has been made
	func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		// This method is triggered whenever the user makes a change to the picker selection.
		// The parameter named row and component represents what was selected.
		
		print("row: \(row)")
		
		// mapping row to CL enum
		let selection = (CurrenciesList(rawValue: row))!
		
		// convert CL enum to string for NSLocale
		let country = codeEnumToString(selection)
		
		print("country: \(country)")
		
		currency.locale = NSLocale(localeIdentifier: country)
		
		// update default locale on any change
		defaults.setValue(country, forKey: "default_locale")
		defaults.synchronize()

		
	}
	
	// End UIPicker overload methods
	// **********************************
	
	override func viewWillAppear(animated: Bool) {
		
		// set the segment to the last stored default
		defaultTipControl.selectedSegmentIndex = defaults.integerForKey("default_tip")
		
		var thisLocale: String
		
		if (defaults.stringForKey("default_locale") == nil)
		{
			thisLocale = NSLocale.preferredLanguages()[0]
		}
		else
		{
			thisLocale = defaults.stringForKey("default_locale")!
		}
		
		let pickerDefault = stringToEnum(thisLocale).rawValue
		
		print(pickerDefault)
		
		localePicker.selectRow(pickerDefault, inComponent: 0, animated: true)
		


	}
	
	override func viewWillDisappear(animated: Bool) {
		
	}
	
	@IBAction func onDefaultChanged(sender: AnyObject) {
		
		// create/update the default selection
		defaults.setInteger(defaultTipControl.selectedSegmentIndex, forKey: "default_tip")
		defaults.synchronize()
		
		print(defaults.integerForKey("default_tip"))
		
	}
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		
		defaults.synchronize()
		
		print("IN SEGUE")
		print(defaults.integerForKey("default_tip"))
	}
	
	/*
	// MARK: - Navigation
	
	// In a storyboard-based application, you will often want to do a little preparation before navigation
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
	// Get the new view controller using segue.destinationViewController.
	// Pass the selected object to the new view controller.
	}
	*/
	
	
	// maps the picker to corresponding country codes
	enum CurrenciesList: Int
	{
		case ps_AF = 0
		case sq_AL
		case ar_DZ
		case es_AR
		case hy_AM
		case en_AU
		case de_AT
		case ar_BH
		case bn_BD
		case be_BY
		case fr_BE
		case es_BO
		case en_BW
		case pt_BR
		case km_KH
		case en_CA
		case es_CL
		case zh_Hans_CN
		case es_CO
		case es_CR
		case es_CU
		case el_CY
		case cs_CZ
		case da_DK
		case so_DJ
		case es_DO
		case es_EC
		case ar_EG
		case es_SV
		case et_EE
		case am_ET
		case fi_FI
		case fr_FR
		case ka_GE
		case de_DE
		case ak_GH
		case el_GR
		case es_GT
		case es_HN
		case zh_Hans_HK
		case hu_HU
		case is_IS
		case en_IN
		case id_ID
		case fa_IR
		case ar_IQ
		case en_IE
		case he_IL
		case it_IT
		case ja_JP
		case ar_JO
		case so_KE
		case ar_KW
		case lo_LA
		case lv_LV
		case ar_LB
		case ar_LY
		case lt_LT
		case de_LU
		case mk_MK
		case mt_MT
		case es_MX
		case mn_Cyrl_MN
		case sr_Cyrl_ME
		case ar_MA
		case ne_NP
		case nl_NL
		case en_NZ
		case es_NI
		case en_NG
		case nb_NO
		case ar_OM
		case ur_PK
		case es_PA
		case es_PY
		case es_PE
		case fil_PH
		case pl_PL
		case pt_PT
		case ar_QA
		case ro_RO
		case ru_RU
		case rw_RW
		case ar_SA
		case ff_SN
		case sr_Cyrl_RS
		case en_SG
		case sk_SK
		case sl_SI
		case so_SO
		case af_ZA
		case ko_KR
		case es_ES
		case si_LK
		case ar_SD
		case sv_SE
		case de_CH
		case ar_SY
		case zh_Hant_TW
		case tg_Cyrl_TJ
		case th_TH
		case ar_TN
		case tr_TR
		case ar_AE
		case ru_UA
		case en_GB
		case en_US
		case es_UY
		case uz_Latn_UZ
		case es_VE
		case vi_VN
		case ar_YE
		
	}

	
	// get a string back from the int enum
	func codeEnumToString(code: CurrenciesList) -> String
	{
		switch code
		{
		case .ps_AF: return "ps_AF"
		case .sq_AL: return "sq_AL"
		case .ar_DZ: return "ar_DZ"
		case .es_AR: return "es_AR"
		case .hy_AM: return "hy_AM"
		case .en_AU: return "en_AU"
		case .de_AT: return "de_AT"
		case .ar_BH: return "ar_BH"
		case .bn_BD: return "bn_BD"
		case .be_BY: return "be_BY"
		case .fr_BE: return "fr_BE"
		case .es_BO: return "es_BO"
		case .en_BW: return "en_BW"
		case .pt_BR: return "pt_BR"
		case .km_KH: return "km_KH"
		case .en_CA: return "en_CA"
		case .es_CL: return "es_CL"
		case .zh_Hans_CN: return "zh_Hans_CN"
		case .es_CO: return "es_CO"
		case .es_CR: return "es_CR"
		case .es_CU: return "es_CU"
		case .el_CY: return "el_CY"
		case .cs_CZ: return "cs_CZ"
		case .da_DK: return "da_DK"
		case .so_DJ: return "so_DJ"
		case .es_DO: return "es_DO"
		case .es_EC: return "es_EC"
		case .ar_EG: return "ar_EG"
		case .es_SV: return "es_SV"
		case .et_EE: return "et_EE"
		case .am_ET: return "am_ET"
		case .fi_FI: return "fi_FI"
		case .fr_FR: return "fr_FR"
		case .ka_GE: return "ka_GE"
		case .de_DE: return "de_DE"
		case .ak_GH: return "ak_GH"
		case .el_GR: return "el_GR"
		case .es_GT: return "es_GT"
		case .es_HN: return "es_HN"
		case .zh_Hans_HK: return "zh_Hans_HK"
		case .hu_HU: return "hu_HU"
		case .is_IS: return "is_IS"
		case .en_IN: return "en_IN"
		case .id_ID: return "id_ID"
		case .fa_IR: return "fa_IR"
		case .ar_IQ: return "ar_IQ"
		case .en_IE: return "en_IE"
		case .he_IL: return "he_IL"
		case .it_IT: return "it_IT"
		case .ja_JP: return "ja_JP"
		case .ar_JO: return "ar_JO"
		case .so_KE: return "so_KE"
		case .ar_KW: return "ar_KW"
		case .lo_LA: return "lo_LA"
		case .lv_LV: return "lv_LV"
		case .ar_LB: return "ar_LB"
		case .ar_LY: return "ar_LY"
		case .lt_LT: return "lt_LT"
		case .de_LU: return "de_LU"
		case .mk_MK: return "mk_MK"
		case .mt_MT: return "mt_MT"
		case .es_MX: return "es_MX"
		case .mn_Cyrl_MN: return "mn_Cyrl_MN"
		case .sr_Cyrl_ME: return "sr_Cyrl_ME"
		case .ar_MA: return "ar_MA"
		case .ne_NP: return "ne_NP"
		case .nl_NL: return "nl_NL"
		case .en_NZ: return "en_NZ"
		case .es_NI: return "es_NI"
		case .en_NG: return "en_NG"
		case .nb_NO: return "nb_NO"
		case .ar_OM: return "ar_OM"
		case .ur_PK: return "ur_PK"
		case .es_PA: return "es_PA"
		case .es_PY: return "es_PY"
		case .es_PE: return "es_PE"
		case .fil_PH: return "fil_PH"
		case .pl_PL: return "pl_PL"
		case .pt_PT: return "pt_PT"
		case .ar_QA: return "ar_QA"
		case .ro_RO: return "ro_RO"
		case .ru_RU: return "ru_RU"
		case .rw_RW: return "rw_RW"
		case .ar_SA: return "ar_SA"
		case .ff_SN: return "ff_SN"
		case .sr_Cyrl_RS: return "sr_Cyrl_RS"
		case .en_SG: return "en_SG"
		case .sk_SK: return "sk_SK"
		case .sl_SI: return "sl_SI"
		case .so_SO: return "so_SO"
		case .af_ZA: return "af_ZA"
		case .ko_KR: return "ko_KR"
		case .es_ES: return "es_ES"
		case .si_LK: return "si_LK"
		case .ar_SD: return "ar_SD"
		case .sv_SE: return "sv_SE"
		case .de_CH: return "de_CH"
		case .ar_SY: return "ar_SY"
		case .zh_Hant_TW: return "zh_Hant_TW"
		case .tg_Cyrl_TJ: return "tg_Cyrl_TJ"
		case .th_TH: return "th_TH"
		case .ar_TN: return "ar_TN"
		case .tr_TR: return "tr_TR"
		case .ar_AE: return "ar_AE"
		case .ru_UA: return "ru_UA"
		case .en_GB: return "en_GB"
		case .en_US: return "en_US"
		case .es_UY: return "es_UY"
		case .uz_Latn_UZ: return "uz_Latn_UZ"
		case .es_VE: return "es_VE"
		case .vi_VN: return "vi_VN"
		case .ar_YE: return "ar_YE"
		}
		
	}
	
	func stringToEnum(code: String) -> CurrenciesList
	{
			switch code
			{
			case "ps_AF": return .ps_AF
			case "sq_AL": return .sq_AL
			case "ar_DZ": return .ar_DZ
			case "es_AR": return .es_AR
			case "hy_AM": return .hy_AM
			case "en_AU": return .en_AU
			case "de_AT": return .de_AT
			case "ar_BH": return .ar_BH
			case "bn_BD": return .bn_BD
			case "be_BY": return .be_BY
			case "fr_BE": return .fr_BE
			case "es_BO": return .es_BO
			case "en_BW": return .en_BW
			case "pt_BR": return .pt_BR
			case "km_KH": return .km_KH
			case "en_CA": return .en_CA
			case "es_CL": return .es_CL
			case "zh_Hans_CN": return .zh_Hans_CN
			case "es_CO": return .es_CO
			case "es_CR": return .es_CR
			case "es_CU": return .es_CU
			case "el_CY": return .el_CY
			case "cs_CZ": return .cs_CZ
			case "da_DK": return .da_DK
			case "so_DJ": return .so_DJ
			case "es_DO": return .es_DO
			case "es_EC": return .es_EC
			case "ar_EG": return .ar_EG
			case "es_SV": return .es_SV
			case "et_EE": return .et_EE
			case "am_ET": return .am_ET
			case "fi_FI": return .fi_FI
			case "fr_FR": return .fr_FR
			case "ka_GE": return .ka_GE
			case "de_DE": return .de_DE
			case "ak_GH": return .ak_GH
			case "el_GR": return .el_GR
			case "es_GT": return .es_GT
			case "es_HN": return .es_HN
			case "zh_Hans_HK": return .zh_Hans_HK
			case "hu_HU": return .hu_HU
			case "is_IS": return .is_IS
			case "en_IN": return .en_IN
			case "id_ID": return .id_ID
			case "fa_IR": return .fa_IR
			case "ar_IQ": return .ar_IQ
			case "en_IE": return .en_IE
			case "he_IL": return .he_IL
			case "it_IT": return .it_IT
			case "ja_JP": return .ja_JP
			case "ar_JO": return .ar_JO
			case "so_KE": return .so_KE
			case "ar_KW": return .ar_KW
			case "lo_LA": return .lo_LA
			case "lv_LV": return .lv_LV
			case "ar_LB": return .ar_LB
			case "ar_LY": return .ar_LY
			case "lt_LT": return .lt_LT
			case "de_LU": return .de_LU
			case "mk_MK": return .mk_MK
			case "mt_MT": return .mt_MT
			case "es_MX": return .es_MX
			case "mn_Cyrl_MN": return .mn_Cyrl_MN
			case "sr_Cyrl_ME": return .sr_Cyrl_ME
			case "ar_MA": return .ar_MA
			case "ne_NP": return .ne_NP
			case "nl_NL": return .nl_NL
			case "en_NZ": return .en_NZ
			case "es_NI": return .es_NI
			case "en_NG": return .en_NG
			case "nb_NO": return .nb_NO
			case "ar_OM": return .ar_OM
			case "ur_PK": return .ur_PK
			case "es_PA": return .es_PA
			case "es_PY": return .es_PY
			case "es_PE": return .es_PE
			case "fil_PH": return .fil_PH
			case "pl_PL": return .pl_PL
			case "pt_PT": return .pt_PT
			case "ar_QA": return .ar_QA
			case "ro_RO": return .ro_RO
			case "ru_RU": return .ru_RU
			case "rw_RW": return .rw_RW
			case "ar_SA": return .ar_SA
			case "ff_SN": return .ff_SN
			case "sr_Cyrl_RS": return .sr_Cyrl_RS
			case "en_SG": return .en_SG
			case "sk_SK": return .sk_SK
			case "sl_SI": return .sl_SI
			case "so_SO": return .so_SO
			case "af_ZA": return .af_ZA
			case "ko_KR": return .ko_KR
			case "es_ES": return .es_ES
			case "si_LK": return .si_LK
			case "ar_SD": return .ar_SD
			case "sv_SE": return .sv_SE
			case "de_CH": return .de_CH
			case "ar_SY": return .ar_SY
			case "zh_Hant_TW": return .zh_Hant_TW
			case "tg_Cyrl_TJ": return .tg_Cyrl_TJ
			case "th_TH": return .th_TH
			case "ar_TN": return .ar_TN
			case "tr_TR": return .tr_TR
			case "ar_AE": return .ar_AE
			case "ru_UA": return .ru_UA
			case "en_GB": return .en_GB
			case "en_US": return .en_US
			case "es_UY": return .es_UY
			case "uz_Latn_UZ": return .uz_Latn_UZ
			case "es_VE": return .es_VE
			case "vi_VN": return .vi_VN
			case "ar_YE": return .ar_YE
				
			default: return .en_US
		}

	}
	
	
}
