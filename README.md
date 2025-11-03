# Vision Transformer Demo

A simple demonstration of image classification using Vision Transformer (ViT) models.

## Quick Start

### Option 1: Automated Setup (Recommended)

```bash
# Run the setup script
./setup.sh

# Download a test image
./download_test_image.sh

# Run the demo
./run.sh dog.jpg
```

### Option 2: Manual Setup

```bash
# Create virtual environment
python3 -m venv venv
source venv/bin/activate

# Install dependencies
pip install -r requirements.txt

# Run demo
python demo.py your_image.jpg
```

### Usage

```bash
# Basic usage - classify an image
./run.sh your_image.jpg

# Show top 10 predictions
./run.sh your_image.jpg 10

# Or manually after activating venv
python demo.py your_image.jpg
```

## Example Output

```
============================================================
Vision Transformer Image Classification Demo
============================================================
Loading model: google/vit-base-patch16-224
Device: cuda

Processing: cat.jpg

Top 5 Predictions:
------------------------------------------------------------
 1. tabby, tabby cat                              87.23%
 2. tiger cat                                     11.45%
 3. Egyptian cat                                   0.89%
 4. lynx, catamount                                0.15%
 5. plastic bag                                    0.03%
============================================================
```

## How It Works

1. **Load Model**: Downloads pre-trained ViT from HuggingFace (first run only)
2. **Process Image**: Resizes and normalizes your image
3. **Classify**: Runs inference to predict image class
4. **Display**: Shows top predictions with confidence scores

## Models You Can Use

The demo uses `google/vit-base-patch16-224` by default. You can modify the code to use:

- `google/vit-large-patch16-224` - Larger model, more accurate
- `google/vit-base-patch16-384` - Higher resolution input
- `facebook/deit-base-distilled-patch16-224` - Alternative ViT variant

## Requirements

- Python 3.8+
- ~500MB free space (for model download)
- GPU optional but recommended for faster inference

## Test Images

If you don't have test images, download some:

```bash
# Download a sample image
wget https://raw.githubusercontent.com/pytorch/hub/master/images/dog.jpg
```

## What is Vision Transformer?

Vision Transformer (ViT) applies the Transformer architecture (from NLP) to images by:
1. Splitting images into patches (like words in text)
2. Processing patches through transformer layers
3. Using attention to understand relationships between patches

This demo uses models trained on ImageNet (1000 classes of common objects).

## Troubleshooting

**Out of memory**: Use CPU by setting `CUDA_VISIBLE_DEVICES=""`

**Slow first run**: Model download takes time, subsequent runs are fast

**Wrong predictions**: Try different images or use a larger model

---

**That's it!** A simple 90-line demo showing how to use Vision Transformers for image classification.

