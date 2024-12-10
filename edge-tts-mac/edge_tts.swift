//
//  Untitled.swift
//  edge-tts-mac
//
//  Created by sanxi on 2024/12/10.
//

import Foundation

class MP3Generator {
    func generateMP3(from text: String, to path: URL, completion: @escaping (Bool, String) -> Void) {
        DispatchQueue.global().async {
            let process = Process()
            // 使用 Bundle 查找 edge-tts 文件路径
            guard let edgeTTSPath = Bundle.main.path(forResource: "edge-tts", ofType: "") else {
                DispatchQueue.main.async {
                    completion(false, "未找到 edge-tts 可执行文件，请检查项目资源。")
                }
                return
            }
            process.executableURL = URL(fileURLWithPath: edgeTTSPath)
            process.arguments = [
                "--text", text,
                "--write-media", path.path
            ]

            do {
                try process.run()
                process.waitUntilExit()
                DispatchQueue.main.async {
                    if process.terminationStatus == 0 {
                        completion(true, "生成成功！文件已保存到：\(path.path)")
                    } else {
                        completion(false, "生成失败，请检查 edge-tts 配置。")
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    completion(false, "发生错误：\(error.localizedDescription)")
                }
            }
        }
    }
}