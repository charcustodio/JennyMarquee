//
//  ContentView.swift
//  Jenny
//
//  Created by aoi on 11/10/20.
//

import SwiftUI

extension String {
   func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }
}

struct ContentView: View {
    @ObservedObject var keyboardResponder = KeyboardResponder()
    @State var orientation = UIDevice.current.orientation.rawValue
    @State var prevorientation = 0
    @State var scrolltext = false
    @State var screenheight = UIScreen.main.bounds.height
    @State var screenwidth = UIScreen.main.bounds.width
    @State var color_scheme: ColorScheme = .dark
    @State var text = "TYPE YOUR MESSAGE"
    @State var textdisplay = ""
    @State var str = ""
    @State var textsize = 250
    @State var textspeed = 0.21
    @State var textlen = 0
    @State var textcount = 0
    @State var textcolor = Color(UIColor.darkGray)
    @State var textlencolor = Color.gray
    @State var textwidth : CGFloat = 0
    @State var textduration = 0.0
    @State var textlim = 20
    
    
    let orientationChanged = NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)
            .makeConnectable()
            .autoconnect()
    
    var body: some View {
        
        let binding = Binding<String>(get: {
            self.text
                }, set: {
                    let impactHeavy = UIImpactFeedbackGenerator(style: .heavy)
                    self.textdisplay = ""
                    self.text = $0.uppercased()
                    self.text = self.text.trimmingCharacters(in: .newlines)
                    self.textlen = self.text.count
                    
                    
                    if self.textlen == 0 {
                        self.textlencolor = Color.gray
                    } else {
                        if self.textlen < self.textlim {
                            self.textlencolor = Color.green
                            self.textcount = 10//Int(self.textlim/self.textlen)
                            self.textdisplay = String(repeating: "\(self.text)       ", count: self.textcount)
                            self.textwidth = CGFloat(self.text.widthOfString(usingFont: UIFont(name: "Futura-CondensedExtraBold", size: CGFloat(self.textsize))!))
                            self.textduration = Double(self.textspeed) * Double(self.textdisplay.count)
                            
                            print("\(self.textdisplay)")
                            print("Word Count \(self.textcount)")
                            print("Speed \(self.textduration)")
                            
                            
                        } else if self.textlen == self.textlim {
                            self.str = self.text
                            self.textlencolor = Color.red
                            impactHeavy.impactOccurred()
                        } else if self.textlen > self.textlim {
                            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                            self.text = self.str
                            self.textlencolor = Color.red
                            impactHeavy.impactOccurred()
                            self.textlen = self.text.count
                       } else {
                            self.textlencolor = Color.green
                       }
                    }
                    
                    if self.text == "TYPE YOUR MESSAGE" {
                        self.textcolor = Color(UIColor.darkGray)
                    } else {
                        self.textcolor = Color.white
                    }
                    
                    
                })
        
            Group {
                if orientation == 1 || orientation == 0 || orientation == 5{
                    VStack (alignment: .leading) {
                        Spacer().frame(height: 100)
                        HStack{
                            Spacer().frame(width: 15)
                            
                            TextEditor(text: binding)
                            .fixedSize(horizontal: false, vertical: true)
                            .font(Font.custom("Futura-CondensedExtraBold", size: 24))
                            .textCase(.uppercase)
                            .keyboardType(.asciiCapable)
                            .foregroundColor(textcolor)
                            .accentColor(.white)
                            .lineSpacing(50)
                            .padding()
                                .onTapGesture() {
                                    if self.text == "TYPE YOUR MESSAGE" {
                                        self.text = ""
                                    }
                                }
                        }
                        Spacer()
                        HStack{
                            Spacer().frame(width: 30)
                            Text(Image("arrow")) + Text(" ROTATE TO DISPLAY")
                            Spacer()
                            //Text("SW\(screenwidth)") // text tester
                            Text("\(textlen)").foregroundColor(self.textlencolor) + Text("/\(textlim)")
                            Spacer().frame(width: 30)
                        }.font(Font.custom("Futura-CondensedExtraBold", size: 14)).foregroundColor(Color(UIColor.darkGray))
                        Spacer().frame(height: 30)
                    }
                    .background(Color.black)
                    .edgesIgnoringSafeArea(.all)
                    .offset(y: -keyboardResponder.currentHeight*0.001)
                    .colorScheme(color_scheme)
                } else if orientation == 4 {
                    VStack {
                        //Text(String(orientation))
                        Text("\(textdisplay)")
                            .fixedSize(horizontal: true, vertical: false)
                            //.position(x:  ( 200 ) , y: ( screenwidth / 2 ))
                            .position(x:  (screenheight + textwidth) , y: ( screenwidth / 2 ))
                            .offset(x: scrolltext ? -( ( textwidth * (CGFloat(textcount))) ) : (textwidth  * (CGFloat(textcount + 1)) ))
                            .animation(Animation.linear(duration: textduration).repeatForever(autoreverses: false))
                            /*.onAppear() {
                                //self.scrolltext.toggle()
                                withAnimation(.spring()) {
                                    scrolltext = true
                                }
                            }*/
                            .onAppear() { self.scrolltext.toggle() }
                            .font(Font.custom("Futura-CondensedExtraBold", size: CGFloat(250)))
                            .foregroundColor(.white)
                            //.border(Color.yellow)
                        
                    }.frame(width: (screenheight + 200) , height: screenwidth)
                    .background(Color.black)
                    .rotationEffect(.degrees(-90))
                    .edgesIgnoringSafeArea(.all)
                } else {
                    VStack {
                        //Text(String(orientation))
                        Text("\(textdisplay)")
                            .fixedSize(horizontal: true, vertical: false)
                            .position(x:  (screenheight + textwidth) , y: ( screenwidth / 2 ))
                            .offset(x: scrolltext ? (screenheight + ( textwidth * (CGFloat(textcount)))) : -( textwidth * (CGFloat(textcount + 1))))
                            .animation(Animation.linear(duration: textduration).repeatForever(autoreverses: false))
                            .onAppear() { self.scrolltext.toggle() }
                            .font(Font.custom("Futura-CondensedExtraBold", size: CGFloat(250)))
                            .foregroundColor(.white)
                            //.border(Color.yellow)
                        
                    }.frame(width: (screenheight + 200) , height: screenwidth)
                    .background(Color.black)
                    .rotationEffect(.degrees(90))
                    .edgesIgnoringSafeArea(.all)
                }
            }.onReceive(orientationChanged) { _ in
                self.prevorientation = self.orientation
                self.orientation = UIDevice.current.orientation.rawValue
            }
        }
}

class KeyboardResponder: ObservableObject {
    @Published var currentHeight: CGFloat = 0
    
    var _center: NotificationCenter

    init(center: NotificationCenter = .default) {
        _center = center
    //4. Tell the notification center to listen to the system keyboardWillShow and keyboardWillHide notification
        _center.addObserver(self, selector: #selector(keyBoardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        _center.addObserver(self, selector: #selector(keyBoardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyBoardWillShow(notification: Notification) {
    if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                withAnimation {
                   currentHeight = keyboardSize.height
                }
            }
        }
    @objc func keyBoardWillHide(notification: Notification) {
            withAnimation {
               currentHeight = 0
            }
        }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
