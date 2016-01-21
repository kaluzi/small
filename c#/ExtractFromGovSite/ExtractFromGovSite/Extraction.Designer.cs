namespace ExtractFromGovSite
{
    partial class Extraction
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.extractBtn = new System.Windows.Forms.Button();
            this.progressBox = new System.Windows.Forms.TextBox();
            this.SuspendLayout();
            // 
            // extractBtn
            // 
            this.extractBtn.Location = new System.Drawing.Point(35, 22);
            this.extractBtn.Name = "extractBtn";
            this.extractBtn.Size = new System.Drawing.Size(204, 37);
            this.extractBtn.TabIndex = 0;
            this.extractBtn.Text = "Start";
            this.extractBtn.UseVisualStyleBackColor = true;
            this.extractBtn.Click += new System.EventHandler(this.extractBtn_Click);
            // 
            // progressBox
            // 
            this.progressBox.Location = new System.Drawing.Point(34, 91);
            this.progressBox.Multiline = true;
            this.progressBox.Name = "progressBox";
            this.progressBox.Size = new System.Drawing.Size(204, 135);
            this.progressBox.TabIndex = 1;
            // 
            // Extraction
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(8F, 16F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(282, 253);
            this.Controls.Add(this.progressBox);
            this.Controls.Add(this.extractBtn);
            this.Name = "Extraction";
            this.Text = "Form1";
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Button extractBtn;
        private System.Windows.Forms.TextBox progressBox;
    }
}

