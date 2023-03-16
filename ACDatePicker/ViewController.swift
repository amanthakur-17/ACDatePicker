//
//  ViewController.swift
//  ACDatePicker
//
//  Created by Aman on 15/03/23.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var datePicker:UIPickerView!
    @IBOutlet weak var timePickerView:UIPickerView!
    @IBOutlet weak var timePickerContainer:UIView!
    @IBOutlet weak var pickerContainer:UIView!
    
    //var delegate:OrderTimeViewControllerDelegate!
    

    var selectedDate = ""
    var selectYear = ""
    var selectMonth = ""
    
    var hour = ""
    var minutes = ""
    var timeformat = ""
    
    var selectDay = ""

    var daysArray = [String]()
    
    var editUpdate = false
    
    var hoursArray = ["01","02","03","04","05","06","07","08","09","10","11","12"]
    var minArray = ["00","01","02","03","04","05","06","07","08","09","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31","32","33","34","35","36","37","38","39","40","41","42","43","44","45","46","47","48","49","50","51","52","53","54","55","56","57","58","59"]
    var timeFormat = ["AM","PM"]
    
    var months = ["Jan","Feb","Mar","Apr","May","June","July","Aug","Sep","Oct","Nov","Dec"]
    
    var pickerComponent:PickerComponentView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupDatePickerView()
        self.timePickerSetup()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onClickCloseButton(_ sender:UIButton){
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func getCurrentDate()->String{
        let date = Date()
        let df = DateFormatter()
        df.dateFormat = "dd MMM yyyy"
        let dateString = df.string(from: date)
        return dateString
    }
    
    func getCurrentTime(format:String)->String{
        let date = Date()
        let df = DateFormatter()
        df.dateFormat = format
        let dateString = df.string(from: date)
        return dateString
    }
    
    func setupDatePickerView(){
        self.months.removeAll()
        for i in 1...12{
            self.months.append("\(self.getModifiedDateFromDateString("\(i)", setFormat: "M", getFormat: "MMM"))")
        }
        let datesAndTime = editUpdate ? self.getModifiedDateFromDateString(self.selectedDate, setFormat: "dd MMM yyyy, hh:mm a", getFormat: "dd MMM yyyy") : getCurrentDate()
        let divisonDate = datesAndTime.components(separatedBy: " ")
        self.selectDay = divisonDate[0]
        self.selectMonth = divisonDate[1]
        self.selectYear = divisonDate[2]
        
        let month = self.getModifiedDateFromDateString(self.selectMonth, setFormat: "MMM", getFormat: "M")
        let totalDaysInMonth = self.getDaysInMonth(month: Int(month)!, year: Int(self.selectYear)!)
        self.daysArray.removeAll()
        for i in 1...totalDaysInMonth!{
            self.daysArray.append("\(self.getModifiedDateFromDateString("\(i)", setFormat: "d", getFormat: "dd"))")
        }
        let daysScroll = self.getModifiedDateFromDateString(selectDay, setFormat: "dd", getFormat: "d")
        datePicker.dataSource = self
        datePicker.delegate = self
       // datePicker.enableMode = .default
        datePicker.selectRow((Int(month)!-1), inComponent: 1, animated: true)
        datePicker.selectRow((Int(daysScroll)!-1), inComponent: 2, animated: true)
        
    }
    
    
    func timePickerSetup(){
        let currentTime = editUpdate ? self.getModifiedDateFromDateString(self.selectedDate, setFormat: "dd MMM yyyy, hh:mm a", getFormat: "hh:mm a") : getCurrentTime(format: "hh:mm a")
        let getCurrentTime = currentTime.components(separatedBy: " ")
        let timeSlot = getCurrentTime[0].components(separatedBy: ":")
        timePickerView.dataSource = self
        timePickerView.delegate = self
        //timePickerView.enableMode = .default
        hour = timeSlot[0]
        minutes = timeSlot[1]
        timeformat = getCurrentTime[1]
        timePickerView.selectRow(Int(timeSlot[0])!-1, inComponent: 0, animated: true)
        timePickerView.selectRow(Int(timeSlot[1])!, inComponent: 1, animated: true)
        let selectIndex = getCurrentTime[1] == "AM" ? 0 : 1
        timePickerView.selectRow(selectIndex, inComponent: 2, animated: true)

    }


}

extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return pickerView == timePickerView ? hoursArray.count : yearsMore_20.count
        case 1:
            return pickerView == timePickerView ? minArray.count : months.count
        case 2:
             self.daysArray = self.updateDays()
            return pickerView == timePickerView ? timeFormat.count : daysArray.count
        default:
            return 0
        }
    }

    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return pickerView.frame.size.width/3
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return pickerView.frame.size.height/3
    }
    


    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == timePickerView{
            switch component{
            case 0:
                self.hour = hoursArray[row]
                return hoursArray[row]
            case 1:
                self.minutes = minArray[row]
                return minArray[row]
            case 2:
                self.timeformat = timeFormat[row]
                return timeFormat[row]
            default:
                return ""
            }
        }else{
        switch component {
        case 0:
            return yearsMore_20[row]
        case 1:
            return months[row]
        case 2:
            return daysArray[row]
            
        default:
            return ""
        }
    }
    }

    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == timePickerView{
            switch component{
            case 0:
                self.hour = hoursArray[row]
                updateTimeAccordingToDate()
            case 1:
                self.minutes = minArray[row]
                updateTimeAccordingToDate()
            case 2:
                self.timeformat = timeFormat[row]
                updateTimeAccordingToDate()
            default:
                break;
            }
        }else{
        switch component {
        case 0:
            self.yearSetup(row: row)
            selectYear = yearsMore_20[row]
            updateTimeAccordingToDate()

        case 1:
            self.selectMonth = months[row]
            self.monthSetup(row: row)
            updateTimeAccordingToDate()

        case 2:
            self.selectDay = daysArray[row]
            self.daySetup(row: row)
            updateTimeAccordingToDate()
        default:
            break;
        }
      }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel: UILabel? = (view as? UILabel)
        if pickerLabel == nil {
            pickerLabel = UILabel()
          //  pickerLabel?.font = fonts.Poppins.semibold.font(.large)//UIFont(name: "Your Font Name", size: 25)
            pickerLabel?.textAlignment = .center
        }
        if pickerView == timePickerView{
            pickerLabel?.text =  component == 0  ? hoursArray[row] : component == 1 ? minArray[row] : timeFormat[row]
        }else{
            self.daysArray = self.updateDays()
          pickerLabel?.text =  component == 0  ? yearsMore_20[row] : component == 1 ? months[row] : daysArray[row]
        }
        for views in pickerView.subviews{
            views.backgroundColor = .clear
        }
        pickerLabel?.textColor = UIColor.white//appColor.appWhite
        pickerLabel?.backgroundColor = UIColor.black.withAlphaComponent(0.6)//appColor.appBgColor
        
        return pickerLabel!
    }
    
    
    func yearSetup(row:Int){
        let year = yearsMore_20[row]
        let newMonth = self.getModifiedDateFromDateString(selectMonth, setFormat: "MMM", getFormat: "M")
        let getCurrentMonth = self.getCurrentMonth(year: Int(year)!, month: Int(newMonth)!)!
        self.selectYear = year
        self.selectMonth = months[getCurrentMonth-1]
        self.datePicker.selectRow(getCurrentMonth-1, inComponent: 1, animated: true)
        self.datePicker.reloadComponent(1)
        if year == (yearsMore_20[0]){
            let calendar = Calendar.current
            let date = Date()
            let currentDay = calendar.component(.day, from: date)
            let getCurrentDay = self.getCurrentDateAndMonthYear(month: Int(newMonth)!, year: Int(year)!, day: currentDay)!
            self.selectDay = self.getModifiedDateFromDateString("\(getCurrentDay)", setFormat: "d", getFormat: "dd")
            self.datePicker.selectRow(getCurrentDay-1, inComponent: 2, animated: true)
            self.datePicker.reloadComponent(2)
            return
        }
        let getCurrentDay = self.getCurrentDay(month: Int(newMonth)!, year: Int(selectYear)!)!
        self.selectDay = self.getModifiedDateFromDateString("\(getCurrentDay)", setFormat: "d", getFormat: "dd")
        self.datePicker.selectRow(getCurrentDay-1, inComponent: 2, animated: true)
        self.datePicker.reloadComponent(2)

    }
    
    func monthSetup(row:Int){
        let calendar = Calendar.current
        let date = Date()
        let currentMonth = calendar.component(.month, from: date)
        let currentYear = calendar.component(.year, from: date)
      //  print_debug("Month =========>>>>>>>> \(currentMonth)   Year =========>>>>>>>> \(currentYear)")
        let month = months[row]
        let newMonth = self.getModifiedDateFromDateString(month, setFormat: "MMM", getFormat: "M")
        self.selectMonth = month
        let getCurrentDay = self.getCurrentDay(month: Int(newMonth)!, year: Int(selectYear)!)!
        self.selectDay = self.getModifiedDateFromDateString("\(getCurrentDay)", setFormat: "d", getFormat: "dd")
        if Int(selectYear) == currentYear && Int(newMonth)! < currentMonth{
            let getCurrentMonth = self.getCurrentMonth(year: Int(selectYear)!, month: Int(newMonth)!)!
            self.selectMonth = months[getCurrentMonth-1]
            self.datePicker.selectRow(getCurrentMonth-1, inComponent: 1, animated: true)
            self.datePicker.reloadComponent(1)
            let getCurrentDay = self.getCurrentDay(month: Int(getCurrentMonth), year: Int(selectYear)!)!
            self.selectDay = self.getModifiedDateFromDateString("\(getCurrentDay)", setFormat: "d", getFormat: "dd")
            self.datePicker.reloadComponent(2)
            self.datePicker.selectRow(getCurrentDay-1, inComponent: 2, animated: true)
           // NKToastHelper.shared.showAlert(self, title: warningMessage.title, message: "Sorry, You can't select smaller date")
            return
        }
        self.datePicker.reloadComponent(2)
        self.datePicker.selectRow(getCurrentDay-1, inComponent: 2, animated: true)

    }
    
    func daySetup(row:Int){
        
        let calendar = Calendar.current
        let date = Date()
        let currentDay = calendar.component(.day, from: date)
        let currentMonth = calendar.component(.month, from: date)
        let currentYear = calendar.component(.year, from: date)
        
       // print_debug("Days =====>>>>>>> \(currentDay)   Month =========>>>>>>>> \(currentMonth)   Year =========>>>>>>>> \(currentYear)")

        self.daysArray = self.updateDays()
        let day = daysArray[row]
        self.selectDay = day
        let newMonth = self.getModifiedDateFromDateString(selectMonth, setFormat: "MMM", getFormat: "M")
        let getDay = self.getCurrentDateAndMonthYear(month: Int(newMonth)!, year: Int(self.selectYear)!, day: Int(day)!)!
        
        if Int(selectYear) == currentYear && Int(newMonth)! == currentMonth && getDay == currentDay{
            self.selectDay = self.getModifiedDateFromDateString("\(getDay)", setFormat: "d", getFormat: "dd")
            self.datePicker.selectRow(getDay-1, inComponent: 2, animated: true)
            //NKToastHelper.shared.showAlert(self, title: warningMessage.title, message: "Sorry, You can't select smaller date")
            return
        }
        self.datePicker.selectRow(getDay-1, inComponent: 2, animated: true)
    }
    
    func updateTimeAccordingToDate(){
        self.getCurrentTimeForCurrentDay(hour: self.hour, minute: self.minutes, timeFormat: self.timeformat)
    }
    
    func updateDays()->[String]{
        let month = self.getModifiedDateFromDateString(self.selectMonth, setFormat: "MMM", getFormat: "M")
        let totalDaysInMonth = self.getDaysInMonth(month: Int(month)!, year: Int(self.selectYear)!)
        var days = [String]()
        days.removeAll()
        for i in 1...totalDaysInMonth!{
        days.append("\(self.getModifiedDateFromDateString("\(i)", setFormat: "d", getFormat: "dd"))")
        }
        return days
    }
    
    
    func getDaysInMonth(month: Int, year: Int) -> Int? {
            let calendar = Calendar.current
            var startComps = DateComponents()
            startComps.day = 1
            startComps.month = month
            startComps.year = year
            var endComps = DateComponents()
            endComps.day = 1
            endComps.month = month == 12 ? 1 : month + 1
            endComps.year = month == 12 ? year + 1 : year
            let startDate = calendar.date(from: startComps)!
            let endDate = calendar.date(from:endComps)!
            let diff = calendar.dateComponents([Calendar.Component.day], from: startDate, to: endDate)
            return diff.day
        }
    
    
    func getCurrentMonth(year: Int,month: Int) -> Int? {
            let calendar = Calendar.current
            let date = Date()
            let currentMonth = (year == calendar.component(.year, from: date)) ? calendar.component(.month, from: date) : 1
            return currentMonth
        }
    
    
    func getCurrentDay(month: Int,year:Int) -> Int? {
            let calendar = Calendar.current
            let date = Date()
            let currentDay = (month == calendar.component(.month, from: date)) && (year == calendar.component(.year, from: date))  ? calendar.component(.day, from: date) : 1
            return currentDay
        }
    
    
    func getCurrentDateAndMonthYear(month: Int,year:Int,day:Int) -> Int? {
            let calendar = Calendar.current
            let date = Date()
        let currentDay = (month == calendar.component(.month, from: date)) && (year == calendar.component(.year, from: date)) && (day <= calendar.component(.day, from: date))  ? calendar.component(.day, from: date) : day
            return currentDay
        }
    
    func getCurrentTimeForCurrentDay(hour:String,minute:String,timeFormat:String){
        let currentTime = self.getCurrentTime(format: "HH:mm a")
        let getCurrent = self.getCurrentDate()
        let getCurrentTime = currentTime.components(separatedBy: " ")
        let timeSlot = getCurrentTime[0].components(separatedBy: ":")
        
        let newHour:Int = timeFormat == "PM" ? Int(hour)!+12 : Int(hour)!
        let slotTIme = Int(timeSlot[0])!>12 ? Int(timeSlot[0])!-12  : Int(timeSlot[0])
        
        // MARK: -Time picker  set Hours

        if getCurrent == "\(self.selectDay) \(self.selectMonth) \(self.selectYear)"{
            if Int(timeSlot[0])! <= newHour{
               timePickerView.selectRow(Int(hour)!-1, inComponent: 0, animated: true)
                self.hour = self.hoursArray[Int(hour)!-1]
                timePickerView.reloadComponent(0)

           }else if Int(timeSlot[0])! >= newHour && getCurrentTime[1] == timeFormat{
                timePickerView.selectRow(slotTIme!-1, inComponent: 0, animated: true)
               self.hour = self.hoursArray[slotTIme!-1]

               timePickerView.reloadComponent(0)

            }else if Int(timeSlot[0])! >= newHour && getCurrentTime[1] != timeFormat{
                timePickerView.selectRow(slotTIme!-1, inComponent: 0, animated: true)
                self.hour = self.hoursArray[slotTIme!-1]
                timePickerView.reloadComponent(0)

            }
            
            // MARK: -Time picker  set minute

            if Int(timeSlot[1])! >= Int(minute)! && Int(timeSlot[0])! >= newHour && getCurrentTime[1] == timeFormat{
                timePickerView.selectRow(Int(timeSlot[1])!, inComponent: 1, animated: true)
                self.minutes = self.minArray[Int(timeSlot[1])!]
                timePickerView.reloadComponent(1)

            }else if Int(timeSlot[1])! >= Int(minute)! && Int(timeSlot[0])! < newHour && getCurrentTime[1] == timeFormat{
                timePickerView.selectRow(Int(minute)!, inComponent: 1, animated: true)
                self.minutes = self.minArray[Int(minute)!]
                timePickerView.reloadComponent(1)

            }else if Int(timeSlot[1])! >= Int(minute)! && Int(timeSlot[0])! < newHour && getCurrentTime[1] != timeFormat{
                timePickerView.selectRow(Int(minute)!, inComponent: 1, animated: true)
                self.minutes = self.minArray[Int(minute)!]

                timePickerView.reloadComponent(1)

            }else if Int(timeSlot[1])! >= Int(minute)! && Int(timeSlot[0])! >= newHour && getCurrentTime[1] != timeFormat{
                timePickerView.selectRow(Int(timeSlot[1])!, inComponent: 1, animated: true)
                self.minutes = self.minArray[Int(timeSlot[1])!]
                timePickerView.reloadComponent(1)

            }else if Int(timeSlot[1])! <= Int(minute)!{
                timePickerView.selectRow(Int(minute)!, inComponent: 1, animated: true)
                self.minutes = self.minArray[Int(minute)!]
                timePickerView.reloadComponent(1)
            }
            
            
            // MARK: - time format set time picker
            if getCurrentTime[1] != timeFormat && Int(timeSlot[0])! >= newHour{
                let selectIndex = getCurrentTime[1] == "AM" ? 0 : 1
                timePickerView.selectRow(selectIndex, inComponent: 2, animated: true)
                timeformat = self.timeFormat[selectIndex]
                timePickerView.reloadComponent(2)
            }else{
                let selectIndex = timeFormat == "AM" ? 0 : 1
                timePickerView.selectRow(selectIndex, inComponent: 2, animated: true)
                timeformat = self.timeFormat[selectIndex]
                timePickerView.reloadComponent(2)

            }
          }
    }
}

extension ViewController{
    
     func getModifiedDateFromDateString(_ dateString: String,setFormat:String,getFormat:String) -> String
      {
          if dateString.isEmpty{return ""}
          let df  = DateFormatter()
          df.locale = Locale.autoupdatingCurrent
          df.timeZone = TimeZone.autoupdatingCurrent
          df.dateFormat = setFormat
          let date = df.date(from: dateString)!
          df.dateFormat = getFormat
          return df.string(from: date);
      }
    var yearsMore_20 : [String] {
        
        func nowCurrentYear() -> Int{
            let calendar = Calendar.current
            var maxDateComponent = calendar.dateComponents([.year], from: Date())
            maxDateComponent.year = maxDateComponent.year!
            let maxDate = calendar.date(from: maxDateComponent)
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy"
            let current = formatter.string(from: maxDate!)
            let year = Int(current) ?? 0
            return year
            
        }
        
        func setMaxYear() -> Int{
            let calendar = Calendar.current
            var maxDateComponent = calendar.dateComponents([.year], from: Date())
            maxDateComponent.year = maxDateComponent.year! + 20
            let maxDate = calendar.date(from: maxDateComponent)
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy"
            let current = formatter.string(from: maxDate!)
            let year = Int(current) ?? 0
            return year
            
        }

        var years = [String]()
        let currentYear = nowCurrentYear()
        let maxYear = setMaxYear()
        for i in (currentYear...maxYear) {
            years.append("\(i)")
        }
        return years
    }
}
