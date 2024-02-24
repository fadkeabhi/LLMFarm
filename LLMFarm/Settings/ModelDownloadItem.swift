//
//  ContactItem.swift
//  ChatUI
//
//  Created by Shezad Ahamed on 6/08/21.
//

import SwiftUI



struct ModelDownloadItem: View {
    
    var modelName: String = ""
    var modelIcon: String = "square.2.layers.3d"
    @State var file_name: String = ""
    @State var orig_file_name: String = ""
    var description: String = ""
    var model_files: [Dictionary<String, String>] = []
    @State var download_url: String = ""
    @State var modelQuantization:String = ""
    var modelSize:String = ""
    var modelInfo:DownloadModelInfo
    
    init(modelInfo: DownloadModelInfo) {
        self.modelInfo = modelInfo
        self.modelName = modelInfo.name ?? "Undefined"
        self.model_files = modelInfo.models ?? []
        if self.model_files.count>0{
            self._modelQuantization = State(initialValue:self.model_files[0]["Q"] ?? "")
            self._download_url = State(initialValue:self.model_files[0]["url"] ?? "")
            self._file_name = State(initialValue:self.model_files[0]["file_name"] ?? "")
        }
    }
    
    
    func model_name_canged(){
        let res = rename_file(orig_file_name,file_name,"models")
        if res {
            orig_file_name = file_name
        }else{
            print("Rename error!")
        }
    }
    
    var body: some View {
        HStack{
            Image(systemName: modelIcon)
                .resizable()
            //                .background( Color("color_bg_inverted").opacity(0.05))
                .padding(EdgeInsets(top: 7, leading: 5, bottom: 7, trailing: 5))
                .frame(width: 40, height: 40)
                .clipShape(Circle())
            VStack(alignment: .leading, spacing: 6){
                
                HStack
                {
                    
                    Text(modelName)
                        .frame( alignment: .leading)
                    
                    Spacer()
                    
                    Menu {
                        
                        Section("Quantization") {
                            ForEach(model_files, id: \.self) { model_info in
                                Button(model_info["Q"]!){
                                    file_name = model_info["file_name"]!
                                    download_url = model_info["url"]!
                                    modelQuantization = model_info["Q"]!
                                }
                            }
                        }
                    } label: {
                        Label(modelQuantization == "" ?"Q":modelQuantization, systemImage: "ellipsis.circle")
                    }
                    .frame( alignment: .trailing)
                    .frame( maxWidth: 90)
                    
                    if download_url != ""{                        
                        DownloadButton(modelName: modelName, modelUrl: download_url, filename:$file_name)
                            .frame( alignment: .trailing)
                            .frame( maxWidth: 50)
                    }
                }
                
                HStack{
                    Text(description)
                        .lineLimit(/*@START_MENU_TOKEN@*/2/*@END_MENU_TOKEN@*/)
                    
                }
                
            }
            .padding(.horizontal, 10)
            
        }
    }
}
