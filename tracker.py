import os
import json
import tkinter as tk
from tkinter import ttk, messagebox

# ==========================================
# ตั้งค่าพาธโฟลเดอร์หลักของคุณตรงนี้
BASE_PATH = r"C:\Users\BasS\Desktop\ALL-Script\PatchControl"
# ไฟล์สำหรับเซฟสถานะการติ๊ก
CURRENT_DIR = r"C:\Users\BasS\Desktop\ALL-Script\PatchControl"
DATA_FILE = os.path.join(CURRENT_DIR, "script_status_save.json")
# ==========================================

class ScriptTrackerApp:
    def __init__(self, root):
        self.root = root
        self.root.title("ระบบตรวจสอบสถานะไฟล์")
        self.root.geometry("1000x600")
        
        self.root.bind_all("<MouseWheel>", self._on_mousewheel)
        self.saved_data = self.load_data()
        
        self.checkbox_states = {}
        self.all_rows = []
        
        top_frame = tk.Frame(root)
        top_frame.pack(fill="x", padx=10, pady=10)
        
        header = tk.Label(top_frame, text="รายชื่อไฟล์แยกตามโปรเจกต์", font=("Arial", 14, "bold"))
        header.pack(side="left")
        
        tk.Label(top_frame, text="🔍 ค้นหาไฟล์:", font=("Arial", 11)).pack(side="left", padx=(30, 5))
        self.search_var = tk.StringVar()
        self.search_var.trace("w", self.filter_rows)
        tk.Entry(top_frame, textvariable=self.search_var, width=30, font=("Arial", 11)).pack(side="left")
        
        # ปุ่มรีเฟรชข้อมูล
        tk.Button(top_frame, text="🔄 รีเฟรชข้อมูล", font=("Arial", 10), bg="#FF9800", fg="white", command=self.refresh_data).pack(side="right", padx=5)
        
        tk.Button(top_frame, text="⬇️ เลื่อนลงล่างสุด", font=("Arial", 10), bg="#2196F3", fg="white", command=self.scroll_to_bottom).pack(side="right", padx=5)

        self.tab_control = ttk.Notebook(root)
        self.tab_control.pack(expand=1, fill="both", padx=10, pady=5)
        
        self.scan_and_build_ui()
        
        save_btn = tk.Button(root, text="💾 บันทึกสถานะการติ๊ก", font=("Arial", 11, "bold"), bg="#4CAF50", fg="white", padx=20, pady=8, command=self.save_data)
        save_btn.pack(pady=10)
        
        self.tab_control.bind("<<NotebookTabChanged>>", lambda e: self.root.after(50, self.scroll_to_bottom))
        self.root.after(100, self.scroll_to_bottom)

    def refresh_data(self):
        """ฟังก์ชันสำหรับเคลียร์หน้าจอและโหลดข้อมูลไฟล์ใหม่"""
        # ลบแท็บเก่าออกให้หมด
        for tab in self.tab_control.tabs():
            tab_widget = self.root.nametowidget(tab)
            tab_widget.destroy()
            
        # เคลียร์ข้อมูลตัวแปร
        self.checkbox_states.clear()
        self.all_rows.clear()
        self.search_var.set("")  # ล้างช่องค้นหา
        
        # โหลดไฟล์ Save ล่าสุด และสแกนสร้าง UI ใหม่
        self.saved_data = self.load_data()
        self.scan_and_build_ui()
        
        messagebox.showinfo("สำเร็จ", "รีเฟรชข้อมูลและโหลดไฟล์ใหม่เรียบร้อยแล้ว!")

    def scroll_to_bottom(self):
        current_tab = self.tab_control.select()
        if current_tab:
            tab_widget = self.root.nametowidget(current_tab)
            for child in tab_widget.winfo_children():
                if isinstance(child, tk.Canvas):
                    child.update_idletasks() 
                    child.yview_moveto(1.0)
                    break

    def filter_rows(self, *args):
        query = self.search_var.get().lower()
        for item in self.all_rows:
            if query in item["path"]:
                for w in item["widgets"]:
                    w.grid()
            else:
                for w in item["widgets"]:
                    w.grid_remove()

    def _on_mousewheel(self, event):
        try:
            widget = self.root.winfo_containing(event.x_root, event.y_root)
            while widget:
                if isinstance(widget, tk.Canvas):   
                    widget.yview_scroll(int(-1 * (event.delta / 120)), "units")
                    break
                parent_name = widget.winfo_parent()
                if not parent_name:
                    break
                widget = self.root.nametowidget(parent_name)
        except Exception:
            pass

    def scan_and_build_ui(self):
        if not os.path.exists(BASE_PATH):
            messagebox.showerror("Error", f"ไม่พบโฟลเดอร์ตามพาธที่กำหนด: {BASE_PATH}")
            return

        for project_name in os.listdir(BASE_PATH):
            project_path = os.path.join(BASE_PATH, project_name)
            
            if os.path.isdir(project_path):
                tab = ttk.Frame(self.tab_control)
                self.tab_control.add(tab, text=f"  {project_name}  ")
                
                header_frame = tk.Frame(tab)
                header_frame.pack(side="top", fill="x", pady=5)
                
                master_dev_var = tk.BooleanVar()
                master_uat_var = tk.BooleanVar()
                master_prod_var = tk.BooleanVar()
                
                tab_vars = {"dev": [], "uat": [], "prod": []}
                
                def get_toggle_cmd(env, m_var, t_vars=tab_vars):
                    return lambda: [v.set(m_var.get()) for v in t_vars[env]]
                
                # เปลี่ยนข้อความเป็น "ชื่อไฟล์"
                tk.Label(header_frame, text="ลำดับ", font=("Arial", 10, "bold"), width=5).grid(row=0, column=0, padx=5)
                tk.Label(header_frame, text="ชื่อไฟล์", font=("Arial", 10, "bold"), width=45, anchor="w").grid(row=0, column=1, padx=5)
                tk.Label(header_frame, text="ไปที่ไฟล์", font=("Arial", 10, "bold"), width=12).grid(row=0, column=2, padx=5)
                tk.Checkbutton(header_frame, text="DEV (All)", font=("Arial", 9, "bold"), variable=master_dev_var, command=get_toggle_cmd("dev", master_dev_var), width=10).grid(row=0, column=3, padx=5)
                tk.Checkbutton(header_frame, text="UAT (All)", font=("Arial", 9, "bold"), variable=master_uat_var, command=get_toggle_cmd("uat", master_uat_var), width=10).grid(row=0, column=4, padx=5)
                tk.Checkbutton(header_frame, text="PROD (All)", font=("Arial", 9, "bold"), variable=master_prod_var, command=get_toggle_cmd("prod", master_prod_var), width=10).grid(row=0, column=5, padx=5)
                
                canvas = tk.Canvas(tab)
                scrollbar = ttk.Scrollbar(tab, orient="vertical", command=canvas.yview)
                scrollable_frame = ttk.Frame(canvas)
                
                scrollable_frame.bind(
                    "<Configure>",
                    lambda e, c=canvas: c.configure(scrollregion=c.bbox("all"))
                )
                canvas.create_window((0, 0), window=scrollable_frame, anchor="nw")
                canvas.configure(yscrollcommand=scrollbar.set)
                
                row_idx = 1
                
                # เก็บรายชื่อไฟล์ทั้งหมด (ไม่มีการกรองนามสกุล)
                target_files = []
                for root_dir, _, files in os.walk(project_path):
                    for file in files:
                        target_files.append((root_dir, file))
                            
                target_files.sort(key=lambda x: x[1])
                
                for root_dir, file in target_files:
                    rel_path = os.path.relpath(os.path.join(root_dir, file), BASE_PATH)
                    widgets_for_this_row = []
                    
                    w0 = tk.Label(scrollable_frame, text=str(row_idx), anchor="center", width=5)
                    w0.grid(row=row_idx, column=0, padx=5, pady=2)
                    widgets_for_this_row.append(w0)
                    
                    w1 = tk.Label(scrollable_frame, text=file, anchor="w", fg="#333", width=45)
                    w1.grid(row=row_idx, column=1, padx=5, pady=2, sticky="w")
                    widgets_for_this_row.append(w1)
                    
                    file_path = os.path.join(root_dir, file)
                    w2 = tk.Button(scrollable_frame, text="📄 เปิดไฟล์", command=lambda p=file_path: os.startfile(p), width=10)
                    w2.grid(row=row_idx, column=2, padx=5, pady=2)
                    widgets_for_this_row.append(w2)
                    
                    old_status = self.saved_data.get(rel_path, {"dev": False, "uat": False, "prod": False})
                    
                    dev_var = tk.BooleanVar(value=old_status["dev"])
                    uat_var = tk.BooleanVar(value=old_status["uat"])
                    prod_var = tk.BooleanVar(value=old_status["prod"])
                    
                    tab_vars["dev"].append(dev_var)
                    tab_vars["uat"].append(uat_var)
                    tab_vars["prod"].append(prod_var)
                    
                    w3 = tk.Checkbutton(scrollable_frame, variable=dev_var, width=10)
                    w3.grid(row=row_idx, column=3, padx=5)
                    widgets_for_this_row.append(w3)
                    
                    w4 = tk.Checkbutton(scrollable_frame, variable=uat_var, width=10)
                    w4.grid(row=row_idx, column=4, padx=5)
                    widgets_for_this_row.append(w4)
                    
                    w5 = tk.Checkbutton(scrollable_frame, variable=prod_var, width=10)
                    w5.grid(row=row_idx, column=5, padx=5)
                    widgets_for_this_row.append(w5)
                    
                    self.checkbox_states[rel_path] = {"dev": dev_var, "uat": uat_var, "prod": prod_var}
                    self.all_rows.append({"path": rel_path.lower(), "widgets": widgets_for_this_row})
                    row_idx += 1
                
                canvas.pack(side="left", fill="both", expand=True)
                scrollbar.pack(side="right", fill="y")

    def load_data(self):
        if os.path.exists(DATA_FILE):
            try:
                with open(DATA_FILE, 'r', encoding='utf-8') as f:
                    return json.load(f)
            except:
                return {}
        return {}

    def save_data(self):
        current_status = {}
        for path, vars_dict in self.checkbox_states.items():
            current_status[path] = {
                "dev": vars_dict["dev"].get(),
                "uat": vars_dict["uat"].get(),
                "prod": vars_dict["prod"].get()
            }
        
        try:
            with open(DATA_FILE, 'w', encoding='utf-8') as f:
                json.dump(current_status, f, ensure_ascii=False, indent=4)
            messagebox.showinfo("สำเร็จ", "บันทึกสถานะเรียบร้อยแล้ว!")
        except Exception as e:
            messagebox.showerror("Error", f"ไม่สามารถบันทึกข้อมูลได้: {e}")

if __name__ == "__main__":
    root = tk.Tk()
    app = ScriptTrackerApp(root)
    root.mainloop()